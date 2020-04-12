//
//  SavedViewModel.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/12.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SavedTableViewData{
    let id = UUID().uuidString
    let vocabulary: Vocabulary
}

extension SavedTableViewData: IdentifiableType, Equatable{
    var identity: String {return id}
    static func == (lhs: SavedTableViewData, rhs: SavedTableViewData) -> Bool {
        return lhs.identity == rhs.identity
    }
}

class SavedViewModel: ListViewModelProtocol {
    
    typealias Data = SavedTableViewData
    typealias SectionModel = AnimatableSectionModel<Int, Data>
    
    var dataObservable: Observable<[SectionModel]> {
        return dataRelay.asObservable()
    }
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
    
    func fetch() {
        VocabularyManager.getAll(disposeBag: disposeBag)
            .subscribe(onNext: { (results) in
                for vocabulary in results {
                    let data = Data(vocabulary: vocabulary)
                    self.toSectionModel(type: data)
                }
            }).disposed(by: disposeBag)
    }
    
    //Realmから削除
    func deleteVocabulary(vocabulary: Vocabulary) {
        VocabularyManager.delete(vocabulary: vocabulary)
    }
    
    //TODO: エラー処理を追加

}
