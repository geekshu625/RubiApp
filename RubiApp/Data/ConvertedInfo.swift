//
//  ConvertInfo.swift
//  RubiApp
//
//  Created by 松木周 on 2020/06/05.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

struct ConvertedInfo {

    var sentence: String
    var convertedSentence: String
    var saveStatus: SaveStatus
    var id: String = UUID().uuidString

}

enum SaveStatus {
    case unSaved
    case saved

    var isStatus: Bool {
        switch self {
        case .saved: return true
        case .unSaved: return false
        }
    }
}
