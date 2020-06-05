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
    func postConvertSentence(sentence: String, completion: @escaping ((Result<ConvertedResponse, AppError>) -> Void))
}

class HomeViewModel: Injectable {


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

    var homeConvertUsecase: HomeConvertSentenseUsecaseProtocol?

    struct Dependency {
        let homeConvertUsecase: HomeConvertSentenseUsecaseProtocol
    }

    required init(dependency: Dependency) {
        self.isLoadingBehavior.accept(false)
        self.resultDataBehavior.accept("")
        self.homeConvertUsecase = dependency.homeConvertUsecase
    }


    func post(sentence: String) {
        self.isLoadingBehavior.accept(true)
        homeConvertUsecase?.postConvertSentence(sentence: sentence, completion: { (result) in
            switch result {
            case .success(let response):
                self.isLoadingBehavior.accept(false)
                self.resultDataBehavior.accept(response.converted)
                let data = Data(hiragana: response, kanzi: sentence)
                self.toSectionModel(type: data)
            case .failure(let error):
                self.bindError(error.errorDescription!)
                self.isLoadingBehavior.accept(false)
            }
        })

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
    private func bindError(_ errorMessage: String) {
        self.alertTrigger.onNext(errorMessage)
    }
}
