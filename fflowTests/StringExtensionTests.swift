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
