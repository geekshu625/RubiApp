//
//  FakeAPIClient.swift
//  RubiAppTests
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import Foundation
@testable import RubiApp

class FakeHiraganaAPIClient: HiraganaAPIClientProtocol {
    
    let fakeResponse: [Hiragana]
    
    init(fakeResponse: [Hiragana]) {
        self.fakeResponse = fakeResponse
    }
    
    func post(completion: @escaping (([Hiragana]?) -> Void)) {
        completion(fakeResponse)
    }
}
