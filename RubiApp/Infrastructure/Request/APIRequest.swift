//
//  APIRequest.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRequest {
    associatedtype ResponseObject: Codable

    var path: String { get }
    var method: HTTPMethod { get }
    var body: BodyData { get }
}

extension APIRequest {
    var method: HTTPMethod {
        return Alamofire.HTTPMethod.post
    }
}

