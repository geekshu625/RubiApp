//
//  Vocabulary.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/11.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RealmSwift

final class Vocabulary: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var kanzi: String = ""
    @objc dynamic var hiragana: String = ""
    @objc dynamic var updatedAt: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
