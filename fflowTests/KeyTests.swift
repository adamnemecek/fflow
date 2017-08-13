//
//  KeyTests.swift
//  fflow
//
//  Created by user on 2016/12/10.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class KeyTests: XCTestCase {

    func testInitByRawValue() {

        let rawNil = Key(rawValue: 200)
        XCTAssertNil(rawNil)
        let R = Key(rawValue: 27)
        XCTAssertEqual(R, .R)
    }

    func testInitFromAny() {

        XCTAssertNil(Key(name: "invalidName"))
        XCTAssertEqual(Key(name: "N"), .N)
        XCTAssertEqual(Key(name: "n"), .N)

        XCTAssertNil(Key(symbol: "invalidSymbol"))
        XCTAssertEqual(Key(symbol: "S"), .S)

        let invalidCode: CGKeyCode = 255
        XCTAssertNil(Key(code: invalidCode))
        XCTAssertEqual(Key(code: 8), .C)
    }

    func testDirect() {

        XCTAssertEqual(Key.Quote.symbol, "'")
        XCTAssertEqual(Key.Equal.symbol, "=")
        XCTAssertEqual(Key.KeypadEquals.symbol, "=")
        XCTAssertEqual(Key.KeypadPlus.symbol, "+")
    }

    func testProperty() {

        let shift = Key.Shift
        XCTAssertEqual(shift.name, "Shift")
        XCTAssertEqual(shift.symbol, "⇧")
        XCTAssertEqual(shift.code, 56)
    }
}
