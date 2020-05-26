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

struct SavedTableViewData {
    let id = UUID().uuidString
    let vocabulary: Vocabulary
}

extension SavedTableViewData: IdentifiableType, Equatable {
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

    //RealmDBから全データを取得する
    func fetchAllVocabulary() {
        remove()
        let vocabularies = VocabularyManager.getAll()
        for vocabulary in vocabularies {
            let data = Data(vocabulary: vocabulary)
            self.toSectionModel(type: data)
        }
    }

    //RealmDBから個別データ削除
    func deleteVocabulary(vocabulary: Vocabulary) {
        VocabularyManager.delete(vocabulary: vocabulary)
    }

    //RealmDBから全データ削除
    func deleteAllVocabulary() {
        VocabularyManager.deleteAll()
        remove()
    }

    //データが2重追加されるのを防止するために、一度空のデータをストリームに流して白紙になるように上書きする
    private func remove() {
        var preItems = dataRelay.value.first?.items ?? []
        guard preItems.count > 0 else {return}
        preItems.removeAll()
        let section = 0
        let sectionModel = SectionModel(model: section, items: preItems)
        dataRelay.accept([sectionModel])
    }

}
