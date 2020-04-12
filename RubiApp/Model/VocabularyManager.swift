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
import RxRealm

final class VocabularyManager {
    
    static let realm: Realm = try! Realm()
    
    // 全件取得
    static func getAll(disposeBag: DisposeBag) -> Observable<Results<Vocabulary>>{
        return Observable.create { observer -> Disposable in
            let vocabulary = realm.objects(Vocabulary.self).sorted(byKeyPath: "updatedAt", ascending: false)
            Observable.collection(from: vocabulary)
                .subscribe(onNext: { (result) in
                    observer.onNext(result)
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    // 保存されているかどうかを確認する
    static func getIsSaved(vocabulary: Vocabulary, disposeBag: DisposeBag) -> Observable<Bool> {
        return Observable.create { observer -> Disposable in
            let data = realm.objects(Vocabulary.self).filter("id == '\(vocabulary.id)'")
            Observable.arrayWithChangeset(from: data)
                .subscribe(onNext: { array, changes in
                  if let changes = changes {
                    if changes.deleted == [] {
                        //保存した時
                        observer.onNext(true)
                    } else {
                        //削除した時
                        observer.onNext(false)
                    }
                } else {
                    //最初の保存はここに流れてくる
                    observer.onNext(true)
                }
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
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
