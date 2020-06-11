//
//  Savelist.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/11.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RealmSwift

final class Savelist: Object {

    @objc dynamic var id: String = ""
    @objc dynamic var kanzi: String = ""
    @objc dynamic var hiragana: String = ""
    @objc dynamic var saveStatus = SaveStatus.unSaved.isStatus

    override class func primaryKey() -> String? {
        return "id"
    }

}
