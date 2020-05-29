//
//  HomeRepositoryTests.swift
//  RubiAppTests
//
//  Created by 松木周 on 2020/05/27.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift

@testable import RubiApp

class HomeRepositoryTests: XCTestCase {

    override func setUp() {
        StubConvertSentence.turnOnStub()
    }

    func testPostConvertSentence() {

        let expectation = self.expectation(description: "expectation")

        let request = HomeRepository.PostConvertSentence(sentence: "変換")
        let body = try? JSONEncoder().encode(request.body)
        let task = AF.upload(body!, with: request.makeRequest())
            .response { (response) in
                defer { expectation.fulfill() }
                switch response.result {
                case .success:
                    guard let data = response.data else { return }

                    //APIのエラー処理
                    if let errorModel = try? JSONDecoder().decode(APIErrorRooter.self, from: data) {
                        XCTFail(AppError.server(errorModel.error.code).localizedDescription)
                    }

                    let hiragana = try? JSONDecoder().decode(ConvertedResponse.self, from: data)
                    XCTAssertEqual(hiragana?.converted, "へんかん")

                case .failure(let error):
                    //ネットワークのエラー処理
                    XCTFail(AppError.network(error._code).localizedDescription)
                }
        }

        task.resume()

        wait(for: [expectation], timeout: 5)

    }


}
