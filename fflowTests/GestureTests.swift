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

    func testAppendDirection() {

        let gesture = Gesture()

        gesture.append(direction: .Up)
        XCTAssertEqual(gesture.string, "U")

        gesture.append(direction: .Down)
        XCTAssertEqual(gesture.string, "UD")

        gesture.append(direction: .Down)
        XCTAssertNotEqual(gesture.string, "UDD")
        XCTAssertEqual(gesture.string, "UD")

        gesture.append(direction: .Vague)
        XCTAssertNotEqual(gesture.string, "UDV")
        XCTAssertEqual(gesture.string, "UD")

        gesture.append(direction: .No)
        XCTAssertEqual(gesture.string, "UDN")
    }

    func testAppendXY() {

        let gesture = Gesture()

        gesture.append(x: 0, y: 7)
        XCTAssertEqual(gesture.string, "D")

        gesture.append(x: 7, y: 0)
        XCTAssertEqual(gesture.string, "DR")

        gesture.append(x: -1, y: -7)
        XCTAssertEqual(gesture.string, "DRU")

        gesture.append(x: -7, y: 1)
        XCTAssertEqual(gesture.string, "DRUL")
    }
}

extension GestureTests {

    func testPath() {

        let elementCountOfRivet = 5
        let elementCountOfLine = 2
        let elementCountOfOnePath = elementCountOfRivet + elementCountOfLine

        let drudu = Gesture(string: "drudu")

        XCTAssertEqual(drudu.path.elementCount, elementCountOfOnePath * 5)
    }
}

extension GestureTests {

    func testSingleDirectionGestureShouldBeCanceled() {

        let u = Gesture(string: "u")
        XCTAssertNil(u.appendAndReleaseIfCan(x: 0, y: 0)?.string)
    }

    func testAppendAndReleaseIfCan() {

        let dr = Gesture()

        XCTAssertNil(dr.appendAndReleaseIfCan(x: 0, y: 10)?.string)
        XCTAssertNil(dr.appendAndReleaseIfCan(x: 10, y: 0)?.string)
        XCTAssertEqual(dr.appendAndReleaseIfCan(x: 0, y: 0)?.string, "DR")

        XCTAssertNil(dr.appendAndReleaseIfCan(x: -10, y: 0)?.string)
        XCTAssertNil(dr.appendAndReleaseIfCan(x: 10, y: 0)?.string)
        XCTAssertEqual(dr.appendAndReleaseIfCan(x: 0, y: 0)?.string, "LR")
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
