//
//  HomeRepository.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import Alamofire

final class HomeRepository {

    struct PostConvertSentence: APIRequest {

        typealias ResponseObject = ConvertedResponse

        let requestId: String = "record001"

        let sentence: String

        let outputType: String = "hiragana"

        var baseUrl: URL {
            return URL(string: "https://api.apigw.smt.docomo.ne.jp/gooLanguageAnalysis/v1/hiragana?APIKEY=\(APIKey)")!
        }

        var method: HTTPMethod {
            return .post
        }

        //TODO: pathとURLに価を設定して通信をするとなぜかnilになり値が帰ってこないのでそれを調査する
        var path: String {
            return ""
        }

        var parameter: [String: Any] {
            return [String: Any]()
        }

        var body: BodyData {
            return BodyData(requestId: requestId, sentence: sentence, outputType: outputType)
        }

    }
}
