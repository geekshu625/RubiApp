//
//  HiraganaManager.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/11.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RealmSwift

final class VocabularyManager {
    
    static let realm: Realm = try! Realm()

    // 全件取得
    static func getAll() -> Results<Vocabulary> {
        return realm.objects(Vocabulary.self).sorted(byKeyPath: "updatedAt", ascending: false)
    }
    
    // 全件削除
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        }
        catch _ {
            // TODO: error処理
        }
    }
    
    // 追加
    static func add(vocabulary: Vocabulary) {
        do {
            try realm.write {
                realm.add(vocabulary)
            }
        }
        catch _ {
            // TODO: error処理
        }
    }
    
    // 削除
    static func delete(vocabulary: Vocabulary) {
        do {
            try realm.write {
                realm.delete(realm.objects(Vocabulary.self).filter("id == '\(vocabulary.id)'"))
            }
        }
        catch _ {
            // TODO: error処理
        }
    }
}
