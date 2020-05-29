//
//  StubConvertKanzi.swift
//  RubiAppTests
//
//  Created by 松木周 on 2020/05/27.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import OHHTTPStubs

final class StubConvertSentence {

    static func turnOnStub() {

        let timestamp = Date.timeIntervalSinceReferenceDate*1000


        let response = [
            "converted": "へんかん",
            "output_type": "hiragana",
            "request_id": "record001"
        ]

        stub(condition: pathEndsWith("v1/hiragana")) { (_) in
            return HTTPStubsResponse.init(jsonObject: response, statusCode: 200, headers: nil)
        }

    }

}

