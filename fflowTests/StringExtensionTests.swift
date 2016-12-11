//
//  StringExtensionTests.swift
//  fflow
//
//  Created by user on 2016/12/11.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class StringExtensionTests: XCTestCase {

    override func setUp() {
        
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFirstIs() {

        let shift = Key.Shift.symbol
        let control = Key.Control.symbol

        let str = shift + control + Key.A.symbol

        XCTAssertTrue(str.firstIs(it: shift))
        XCTAssertFalse(str.firstIs(it: control))
    }

    func testTrimmingLeading() {

        let s = "nnnasdf"
        XCTAssertEqual(s.trimmingLeading(character: "n"), "asdf")
    }
}
