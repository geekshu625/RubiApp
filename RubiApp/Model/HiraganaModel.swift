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
    
    static func post(request_id: String, sentence: String, output_type: String) -> Observable<Hiragana>  {
        let request = HiraganaAPI.PostKanzi.init(request_id: request_id, sentence: sentence, output_type: output_type)
        return self.apiClient.call(request: request)
    }
}
