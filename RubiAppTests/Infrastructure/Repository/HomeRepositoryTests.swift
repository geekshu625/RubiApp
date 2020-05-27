//
//  HomeRepositoryTests.swift
//  RubiAppTests
//
//  Created by 松木周 on 2020/05/27.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import XCTest
import RxSwift

@testable import RubiApp

class HomeRepositoryTests: XCTestCase {

    override func setUp() {
        StubConvertKanzi.turnOnStub()
    }

    func testConvertKanzi() {

        let expectation = self.expectation(description: "expectation")
        HiraganaModel.post(sentence: "変換")
            .subscribe(onNext: { (response) in
                defer { expectation.fulfill() }
                XCTAssertEqual(response.converted, "へんかん")
            })

        wait(for: [expectation], timeout: 5)

    }


}
