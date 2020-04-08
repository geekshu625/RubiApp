//
//  RubiAppTests.swift
//  RubiAppTests
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import XCTest
@testable import RubiApp
/*
TODO: 今後するべきテスト
- ルビ変換ボタン押下時にサーバへリクエストを投げているか
- 正しくサーバにパラメータを渡しているか
- サーバとの通信が失敗した場合
- サーバから返ってきたJSONデータが想定と異なる場合
- サーバから返ってきたデータを正しく表示できているか
*/

class RubiAppTests: XCTestCase {
    
    var vc: ViewController!

    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.vc = storyboard.instantiateInitialViewController() as? ViewController
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        vc.loadViewIfNeeded()
        let hiragana = Hiragana(converted: "漢字")
        let client = FakeHiraganaAPIClient(fakeResponse: [hiragana])
        vc = ViewController(client: client)

        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        XCTAssertEqual(vc.titleLabel.text, "漢字")
    }

}
