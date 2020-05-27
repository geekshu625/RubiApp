//
//  BodyData.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

struct BodyData: Codable {
    var requestId: String
    var sentence: String
    var outputType: String

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case sentence
        case outputType = "output_type"
    }
}
