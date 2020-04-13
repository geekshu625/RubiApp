//
//  APIError.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/13.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

struct APIErrorRooter: Codable{
    let error: APIError
}

struct APIError: Codable{
    let code: Int
}

struct HiraganaAPIError: Error {
    
    var message: String
    init(errorCode: Int) {
        
        switch errorCode {
        case 413:
            message = "利用可能な上限に達しました。しばらく経ってからご利用ください"
        case 500:
            message = "サービスで障害が発生しました。回復までお待ち下さい"
        default:
            message = "APIエラーが発生しました"
        }
    }
}
