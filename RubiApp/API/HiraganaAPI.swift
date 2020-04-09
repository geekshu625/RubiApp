//
//  HiraganaAPI.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

final class HiraganaAPI {
    
    struct PostKanzi: APIRequest {
        
        typealias ResponseObject = Hiragana
        
        let request_id: String
        let sentence: String
        let output_type: String
        
        var path: String {
            return "https://api.apigw.smt.docomo.ne.jp/gooLanguageAnalysis/v1/hiragana?APIKEY=\(APIKey)"
        }
        
        var body: BodyData {
            return BodyData(request_id: request_id, sentence: sentence, output_type: output_type)
        }
        
    }
}
