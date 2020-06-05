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
    var saveState: SaveState

}

enum SaveState: String {
    case unSaved
    case saved
}
