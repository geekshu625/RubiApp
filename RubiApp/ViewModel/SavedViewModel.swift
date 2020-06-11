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

class SavedViewModel {

    var convertedInfo = [ConvertedInfo]()

    var dataObservable: Observable<[ConvertedInfo]> {
        return dataRelay.asObservable()
    }
    private let dataRelay = BehaviorRelay<[ConvertedInfo]>(value: [])
    private let disposeBag = DisposeBag()

    //RealmDBから全データを取得する
    func fetchAllVocabulary() {

    }

    //RealmDBから個別データ削除
    func deleteVocabulary(vocabulary: Savelist) {
        SavelistManager.delete(savelist: vocabulary)
    }

    //RealmDBから全データ削除
    func deleteAllVocabulary() {
        SavelistManager.deleteAll()
    }

}
