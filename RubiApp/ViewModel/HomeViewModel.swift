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
    }

    func convert(sentence: String) {

        self.isLoadingBehavior.accept(true)

        homeConvertUsecase?.postConvertSentence(sentence: sentence, completion: { (result) in

            switch result {
            case .success(let response):
                self.isLoadingBehavior.accept(false)
                let info = ConvertedInfo(sentence: sentence, convertedSentence: (self.homeConvertUsecase?.convertedSentence!.converted)!, saveState: .unSaved)
                self.convertedInfo.append(info)
                self.sentenceBehavior.accept(sentence)
                self.loadCompleteBehavior.accept(self.convertedInfo)

            case .failure(let error):
                self.bindError(error.errorDescription!)
                self.isLoadingBehavior.accept(false)
            }

        })

    }

    func tappedSavedButton(saveState: SaveState, savelist: Savelist) {

        switch saveState {
        case .saved:
            deleteSavelist(vocabulary: savelist)

        case .unSaved:
            addSaveList(savelist: savelist)

        default:
            break
        }

    }

    //Realmに保存
    func addSaveList(savelist: Savelist) {
        SavelistManager.add(savelist: savelist)
    }

    //Realmから削除
    func deleteSavelist(vocabulary: Savelist) {
        SavelistManager.delete(savelist: vocabulary)
    }

    //TODO: エラー処理を追加
    private func bindError(_ errorMessage: String) {
        self.alertTrigger.onNext(errorMessage)
    }

}
