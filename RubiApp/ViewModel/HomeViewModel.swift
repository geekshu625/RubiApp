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

struct HiraganaData{
    let id = UUID().uuidString
    let hiragana: Hiragana
}

extension HiraganaData: IdentifiableType, Equatable{
    var identity: String {return id}
    static func == (lhs: HiraganaData, rhs: HiraganaData) -> Bool {
        return lhs.identity == rhs.identity
    }
}

class HomeViewModel: ListViewModelProtocol {
    
    typealias Data = HiraganaData
    typealias SectionModel = AnimatableSectionModel<Int, Data>
    
    var dataObservable: Observable<[SectionModel]> {
        return dataRelay.asObservable()
    }
    
    lazy var isLoading: SharedSequence<DriverSharingStrategy, Bool> = {
        return self.isLoadingBehavior.asDriver()
    }()
    private var isLoadingBehavior = BehaviorRelay<Bool>(value: false)
    let alertTrigger = PublishSubject<String>()
    private let dataRelay = BehaviorRelay<[SectionModel]>(value: [])
    private let disposeBag = DisposeBag()
    
    private func toSectionModel(shouldRefresh: Bool = false, type: Data) {
        var preItems = dataRelay.value.first?.items ?? []
        preItems.append(type)
        let items = shouldRefresh ? [type] : preItems
        let section = 0
        let sectionModel  = SectionModel(model: section, items: items)
        dataRelay.accept([sectionModel])
    }
    
    func post(request_id: String, sentence: String, output_type: String) {
        remove()
        HiraganaModel.post(request_id: request_id, sentence: sentence, output_type: output_type)
            .subscribe(onNext: { (data) in
                let data = Data(hiragana: data)
                self.toSectionModel(type: data)
            }).disposed(by: disposeBag)
    }

    func remove() {
        var preItems = dataRelay.value.first?.items ?? []
        guard preItems.count > 0 else {return}
        preItems.removeAll()
        let section = 0
        let sectionModel = SectionModel(model: section, items: preItems)
        dataRelay.accept([sectionModel])
    }
    
    //TODO: エラー処理を追加

}
