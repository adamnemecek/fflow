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

    override func setUp() {

        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitByRawValue() {

        let rawNil = Key(rawValue: 200)
        XCTAssertNil(rawNil)
        let R = Key(rawValue: 27)
        XCTAssertEqual(R, .R)
    }

    func testInitFromAny() {

        XCTAssertNil(Key(fromName: "invalidName"))
        XCTAssertEqual(Key(fromName: "N"), .N)
        XCTAssertEqual(Key(fromName: "n"), .N)
        
        XCTAssertNil(Key(fromSymbol: "invalidSymbol"))
        XCTAssertEqual(Key(fromSymbol: "S"), .S)

        let invalidCode: CGKeyCode = 255
        XCTAssertNil(Key(fromCode: invalidCode))
        XCTAssertEqual(Key(fromCode: 8), .C)
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
