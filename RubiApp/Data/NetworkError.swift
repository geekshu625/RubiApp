//
//  NetworkError.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/13.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

struct NetworkError: Error {
    var message: String

    init(errorCode: Int) {

        switch errorCode {
        case -1001:
            message = "通信がタイムアウトしました。電波環境の良い場所で再度お試しください"
        case -1009:
            message = "ネットワークに接続されていません"
        default:
            message = "通信エラーが発生しました"
        }
    }
}
