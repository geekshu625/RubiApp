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

    static func post(sentence: String) -> Observable<ConvertedResponse> {
        let request = HomeRepository.PostKanzi.init(sentence: sentence)
        return self.apiClient.call(request: request)
    }
}
