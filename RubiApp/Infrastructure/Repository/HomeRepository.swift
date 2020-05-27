//
//  HomeRepository.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

final class HomeRepository {

    struct PostKanzi: APIRequest {

        typealias ResponseObject = ConvertedResponse

        let requestId: String
        let sentence: String
        let outputType: String

        var path: String {
            return "https://api.apigw.smt.docomo.ne.jp/gooLanguageAnalysis/v1/hiragana?APIKEY=\(APIKey)"
        }

        var body: BodyData {
            return BodyData(requestId: requestId, sentence: sentence, outputType: outputType)
        }

    }
}
