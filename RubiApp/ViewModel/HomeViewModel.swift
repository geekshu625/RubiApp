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
import RxDataSources
import RealmSwift

struct HomeTableViewData{
    let id = UUID().uuidString
    let hiragana: Hiragana
    let kanzi: String
}

extension HomeTableViewData: IdentifiableType, Equatable{
    var identity: String {return id}
    static func == (lhs: HomeTableViewData, rhs: HomeTableViewData) -> Bool {
        return lhs.identity == rhs.identity
    }
}

class HomeViewModel: ListViewModelProtocol {
    
    typealias Data = HomeTableViewData
    typealias SectionModel = AnimatableSectionModel<Int, Data>
    
    var dataObservable: Observable<[SectionModel]> {
        return dataRelay.asObservable()
    }
    private let dataRelay = BehaviorRelay<[SectionModel]>(value: [])
    
    //インディケーターの状態を保持している
    lazy var isLoading: SharedSequence<DriverSharingStrategy, Bool> = {
        return self.isLoadingBehavior.asDriver()
    }()
    private var isLoadingBehavior = BehaviorRelay<Bool>(value: false)
    
    //保存しているかどうかの状態を保持している
//    lazy var isSaved: SharedSequence<DriverSharingStrategy, Bool> = {
//        return self.isSavedBehavior.asDriver()
//    }()
//    private var isSavedBehavior = BehaviorRelay<Bool>(value: SaveVocabulary(isSaved: false))
    
    //変換したひらがなを保持している
    lazy var resultData: SharedSequence<DriverSharingStrategy, String> = {
        return self.resultDataBehavior.asDriver()
    }()
    private var resultDataBehavior = BehaviorRelay<String>(value: "")
    
    let alertTrigger = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.isLoadingBehavior.accept(false)
        self.resultDataBehavior.accept("")
    }
    
    private func toSectionModel(shouldRefresh: Bool = false, type: Data) {
        var preItems = dataRelay.value.first?.items ?? []
        preItems.append(type)
        let items = shouldRefresh ? [type] : preItems
        let section = 0
        let sectionModel  = SectionModel(model: section, items: items)
        dataRelay.accept([sectionModel])
    }
    
    func post(request_id: String, sentence: String, output_type: String) {
        self.isLoadingBehavior.accept(true)
        HiraganaModel.post(request_id: request_id, sentence: sentence, output_type: output_type)
            .subscribe(onNext: { (data) in
                self.isLoadingBehavior.accept(false)
                self.resultDataBehavior.accept(data.converted)
                let data = Data(hiragana: data, kanzi: sentence)
                self.toSectionModel(type: data)
            },onError: { (error) in
                self.bindError(error)
                self.isLoadingBehavior.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    //保存されているかどうかを取得
//    func fetch() {
//        VocabularyManager.getIsSaved(disposeBag: disposeBag)
//            .subscribe(onNext: { (saveVocablary) in
//                self.isSavedBehavior.accept(saveVocablary)
//            })
//        .disposed(by: disposeBag)
//    }
    
    //Realmに保存
    func createVocabulary(vocabulary: Vocabulary) {
        VocabularyManager.add(vocabulary: vocabulary)
    }
    
    //Realmから削除
    func deleteVocabulary(vocabulary: Vocabulary) {
        VocabularyManager.delete(vocabulary: vocabulary)
    }
    //TODO: エラー処理を追加
    private func bindError(_ error: Error) {
        switch error {
        case let error as HiraganaAPIError:
            self.alertTrigger.onNext(error.message)
        case let error as ConnectionError:
            self.alertTrigger.onNext(error.message)
        default:
            self.alertTrigger.onNext(error.localizedDescription)
        }
    }
}
