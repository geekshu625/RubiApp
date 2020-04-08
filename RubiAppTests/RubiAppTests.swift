//
//  RubiAppTests.swift
//  RubiAppTests
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import XCTest
@testable import RubiApp

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
    }

}
