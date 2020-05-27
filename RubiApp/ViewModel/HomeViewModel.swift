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

struct HomeTableViewData {
    let id = UUID().uuidString
    let hiragana: ConvertedResponse
    let kanzi: String
}

extension HomeTableViewData: IdentifiableType, Equatable {
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

    //変換したひらがなを保持している
    lazy var resultData: SharedSequence<DriverSharingStrategy, String> = {
        return self.resultDataBehavior.asDriver()
    }()
    private var resultDataBehavior = BehaviorRelay<String>(value: "")

    let alertTrigger = PublishSubject<String>()
    private let disposeBag = DisposeBag()

    var homeConvertUsecase: HomeConvertUsecaseProtocl?

    init(homeConvertUsecase: HomeConvertUsecaseProtocl) {
        self.isLoadingBehavior.accept(false)
        self.resultDataBehavior.accept("")
        self.homeConvertUsecase = homeConvertUsecase
    }

    private func toSectionModel(shouldRefresh: Bool = false, type: Data) {
        var preItems = dataRelay.value.first?.items ?? []
        preItems.append(type)
        let items = shouldRefresh ? [type] : preItems
        let section = 0
        let sectionModel  = SectionModel(model: section, items: items)
        dataRelay.accept([sectionModel])
    }

    func post(sentence: String) {
        self.isLoadingBehavior.accept(true)
        //TODO: requestはHomeUsecase層がもつべきであるので修正する→現在RequestのResponseObject型になっているからusecase側で返す型を明確にする
        let request = HomeRepository.PostKanzi(sentence: sentence)
        homeConvertUsecase?.postKanzi(request: request)
            .subscribe(onNext: { (data) in
                self.isLoadingBehavior.accept(false)
                self.resultDataBehavior.accept(data.converted)
                let data = Data(hiragana: data, kanzi: sentence)
                self.toSectionModel(type: data)
            }, onError: { (error) in
                self.bindError(error)
                self.isLoadingBehavior.accept(false)
            })
            .disposed(by: disposeBag)
    }
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
