//
//  HiraganaManager.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/11.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

final class SavelistManager {

    // swiftlint:disable:next force_try
    static var realm: Realm = try! Realm()

    // 全件取得
    static func getAll() -> Results<Savelist> {
        return realm.objects(Savelist.self).sorted(byKeyPath: "updatedAt", ascending: false)
    }

    // 全件削除
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch _ {
            // TODO: error処理
        }
    }

    // 追加
    static func add(savelist: Savelist) {
        do {
            try realm.write {
                realm.add(savelist)
            }
        } catch _ {
            // TODO: error処理
        }
    }

    // 削除
    static func delete(savelist: Savelist) {
        do {
            try realm.write {
                realm.delete(realm.objects(Savelist.self).filter("id == '\(savelist.id)'"))
            }
        } catch _ {
            // TODO: error処理
        }
    }
}
