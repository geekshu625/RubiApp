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

    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    var body: BodyData { get }
    func makeRequest() -> URLRequest
}

extension APIRequest {

    func makeRequest() -> URLRequest {

        let url = path.isEmpty ? baseUrl: baseUrl.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if !parameter.isEmpty {

            if let request = try? URLEncoding.default.encode(urlRequest, with: parameter) {
                urlRequest = request
            }

        }

        return urlRequest

    }

}
