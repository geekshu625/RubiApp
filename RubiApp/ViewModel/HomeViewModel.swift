//
//  HomeViewModel.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

protocol HomeConvertSentenseUsecaseProtocol: AnyObject {
    var convertedSentence: ConvertedResponse? { get }
    func postConvertSentence(sentence: String, completion: @escaping ((Result<Void, AppError>) -> Void))
}

class HomeViewModel: Injectable {

    var convertedInfo = [ConvertedInfo]()

    //インディケーターの状態を保持している
    lazy var isLoading: SharedSequence<DriverSharingStrategy, Bool> = {
        return self.isLoadingBehavior.asDriver()
    }()
    private var isLoadingBehavior = BehaviorRelay<Bool>(value: false)

    lazy var loadComplete: SharedSequence<DriverSharingStrategy, [ConvertedInfo]> = {
        return self.loadCompleteBehavior.asDriver()
    }()
    private var loadCompleteBehavior = BehaviorRelay<[ConvertedInfo]>(value: [ConvertedInfo]())

    lazy var sentence: SharedSequence<DriverSharingStrategy, String> = {
        return self.sentenceBehavior.asDriver()
    }()
    private var sentenceBehavior = BehaviorRelay<String>(value: "")

    let alertTrigger = PublishSubject<String>()
    private let disposeBag = DisposeBag()

    var homeConvertUsecase: HomeConvertSentenseUsecaseProtocol?

    struct Dependency {
        let homeConvertUsecase: HomeConvertSentenseUsecaseProtocol
    }

    required init(dependency: Dependency) {

        self.isLoadingBehavior.accept(false)
        self.homeConvertUsecase = dependency.homeConvertUsecase
        observeSavelist()
        
    }

    func convert(sentence: String) {

        self.isLoadingBehavior.accept(true)

        homeConvertUsecase?.postConvertSentence(sentence: sentence, completion: { (result) in

            switch result {
            case .success(let response):
                self.isLoadingBehavior.accept(false)
                let info = ConvertedInfo(sentence: sentence, convertedSentence: (self.homeConvertUsecase?.convertedSentence!.converted)!, saveStatus: .unSaved)
                self.convertedInfo.append(info)
                self.sentenceBehavior.accept(sentence)
                self.loadCompleteBehavior.accept(self.convertedInfo)

            case .failure(let error):
                self.bindError(error.errorDescription!)
                self.isLoadingBehavior.accept(false)
            }

        })

    }

    private func observeSavelist() {

        let realm = try? Realm()
        let savelist = realm!.objects(Savelist.self)

        Observable.changeset(from: savelist)
            .subscribe(onNext: { (resultList, changes) in
                if let changes = changes {

                    //realmに値が追加された時の処理
                    if changes.inserted.count > 0 {

                        changes.inserted.map { (index) in
                            self.updateToSavedStatus(updateId: resultList[index].id)
                        }

                    }

                    //realmから削除された時の処理
                    NotificationCenter.default.addObserver(self, selector: #selector(self.updateToUnSavedStatus(notification:)), name: .deleteSavelistFromRealm, object: nil)

                }

            })
            .disposed(by: disposeBag)

    }

    private func updateToSavedStatus(updateId: String) {

        if let index = convertedInfo.firstIndex(where: {$0.id == updateId}) {
            convertedInfo[index].saveStatus = .saved
            self.loadCompleteBehavior.accept(convertedInfo)
        }

    }

    @objc private func updateToUnSavedStatus(notification: NSNotification?) {
        // swiftlint:disable:next force_cast
        let deleteId = notification?.userInfo!["deleteId"] as! String
        if let index = convertedInfo.firstIndex(where: {$0.id == deleteId}) {
            convertedInfo[index].saveStatus = .unSaved
            self.loadCompleteBehavior.accept(convertedInfo)
        }

    }

    func tappedSavedButton(saveState: SaveStatus, savelist: Savelist) {

        switch saveState {
        case .saved:
            deleteSavelist(savelist: savelist)

        case .unSaved:
            addSavelist(savelist: savelist)

        default:
            break
        }

    }

    //Realmに保存
    func addSavelist(savelist: Savelist) {
        SavelistManager.add(savelist: savelist)
    }

    //Realmから削除
    func deleteSavelist(savelist: Savelist) {
        SavelistManager.delete(savelist: savelist)
    }

    //TODO: エラー処理を追加
    private func bindError(_ errorMessage: String) {
        self.alertTrigger.onNext(errorMessage)
    }

}
