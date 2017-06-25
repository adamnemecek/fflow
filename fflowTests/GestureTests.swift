//
//  GestureTests.swift
//  fflow
//
//  Created by user on 2016/12/09.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class GestureTests: XCTestCase {

    func testInit() {

        XCTAssertNotNil(Gesture())
    }

    func testInitFromString() {

        XCTAssertNotNil(Gesture(string: ""))
        XCTAssertNotNil(Gesture(string: "asDF"))
    }

    func testString() {

        XCTAssertEqual(Gesture(string: "UD").string, "UD")
        XCTAssertEqual(Gesture(string: "ASDF").string, "D")
    }
}

extension GestureTests {

    func testPath() {

        let elementCountOfRivet = 5
        let elementCountOfLine = 2
        let elementCountOfJoint = 3

        let elementCountOfFirstPath = elementCountOfRivet + elementCountOfLine
        let elementCountByElsePath = elementCountOfRivet + elementCountOfLine + elementCountOfJoint

        let drudu = Gesture(string: "drudu")

        XCTAssertEqual(drudu.path.elementCount, elementCountOfFirstPath + elementCountByElsePath * 4)
    }
}

extension GestureTests {

    func testSingleDirectionGestureShouldBeCanceled() {

        let u = Gesture(string: "u")
        XCTAssertNil(u.appendAndReleaseIfCan(direction: .No)?.string)
    }

    func testAppendAndReleaseIfCan() {

        let dr = Gesture()

        XCTAssertNil(dr.appendAndReleaseIfCan(direction: .Down)?.string)
        XCTAssertNil(dr.appendAndReleaseIfCan(direction: .Right)?.string)
        XCTAssertEqual(dr.appendAndReleaseIfCan(direction: .No)?.string, "DR")

        XCTAssertNil(dr.appendAndReleaseIfCan(direction: .Left)?.string)
        XCTAssertNil(dr.appendAndReleaseIfCan(direction: .Right)?.string)
        XCTAssertEqual(dr.appendAndReleaseIfCan(direction: .No)?.string, "LR")
    }
}

extension GestureTests {

    func testArrowString() {

        let ud = Gesture(string: "ud")
        XCTAssertEqual(ud.arrowString, Key.UpArrow.symbol + Key.DownArrow.symbol)

        let lr = Gesture(string: "lr")
        XCTAssertEqual(lr.arrowString, Key.LeftArrow.symbol + Key.RightArrow.symbol)
    }
}
