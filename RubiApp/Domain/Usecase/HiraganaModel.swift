//
//  HiraganaModel.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import RxSwift

struct HiraganaModel {
    static let apiClient = HiraganaAPIClient()

    static func post(requestId: String, sentence: String, outputType: String) -> Observable<Hiragana> {
        let request = HiraganaAPI.PostKanzi.init(requestId: requestId, sentence: sentence, outputType: outputType)
        return self.apiClient.call(request: request)
    }
}
