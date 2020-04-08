//
//  APIClientProtocol.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation

protocol HiraganaAPIClientProtocol {
    func post(completion: @escaping (([Hiragana]?) -> Void))
}
