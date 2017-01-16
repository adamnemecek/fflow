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

    override func setUp() {

        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {

        XCTAssertNotNil(Gesture())
    }

    func testInitFromString() {

        XCTAssertNotNil(Gesture(fromString: ""))
        XCTAssertNotNil(Gesture(fromString: "asdf"))
    }

    func testString() {

        XCTAssertEqual(Gesture(fromString: "ud").string, "ud")
        XCTAssertEqual(Gesture(fromString: "asdf").string, "d")
    }

    func testAppendDirection() {

        let gesture = Gesture()

        gesture.append(direction: .Up)
        XCTAssertEqual(gesture.string, "u")

        gesture.append(direction: .Down)
        XCTAssertEqual(gesture.string, "ud")

        gesture.append(direction: .Down)
        XCTAssertNotEqual(gesture.string, "udd")
        XCTAssertEqual(gesture.string, "ud")

        gesture.append(direction: .Vague)
        XCTAssertNotEqual(gesture.string, "udv")
        XCTAssertEqual(gesture.string, "ud")

        gesture.append(direction: .No)
        XCTAssertEqual(gesture.string, "udn")
    }

    func testAppendXY() {

        let gesture = Gesture()

        gesture.append(x: 0, y: 7)
        XCTAssertEqual(gesture.string, "d")

        gesture.append(x: 7, y: 0)
        XCTAssertEqual(gesture.string, "dr")

        gesture.append(x: -1, y: -7)
        XCTAssertEqual(gesture.string, "dru")

        gesture.append(x: -7, y: 1)
        XCTAssertEqual(gesture.string, "drul")
    }

    func testRelease() {

        let drun = Gesture(fromString: "drun")
        XCTAssertEqual(drun.string, "drun")
        let druString = drun.release()
        XCTAssertEqual(druString, "dru")
        XCTAssertEqual(drun.string, "")

        let r = Gesture(fromString: "nr")
        XCTAssertEqual(r.string, "r")
        let nilString = r.release()
        XCTAssertNil(nilString)
        XCTAssertEqual(r.string, "r")

        let rdn = r
        rdn.append(direction: .Down)
        rdn.append(direction: .No)
        XCTAssertEqual(rdn.string, "rdn")

        let rdString = rdn.release()
        XCTAssertEqual(rdString, "rd")
        XCTAssertEqual(rdn.string, "")
    }
}

extension GestureTests {

    func testPath() {

        let elementCountOfRivet = 5
        let elementCountOfLine = 2
        let elementCountOfOnePath = elementCountOfRivet + elementCountOfLine

        let drudu = Gesture(fromString: "drudu")

        XCTAssertEqual(drudu.path.elementCount, elementCountOfOnePath * 5)
    }
}

extension GestureTests {

    func testSingleDirectionGestureShouldBeCanceled() {

        let u = Gesture(fromString: "u")
        XCTAssertNil(u.appendAndReleaseIfCan(x: 0, y: 0)?.string)
    }

    func testAppendAndReleaseIfCan() {

        let dr = Gesture()

        XCTAssertNil(dr.appendAndReleaseIfCan(x: 0, y: 10)?.string)
        XCTAssertNil(dr.appendAndReleaseIfCan(x: 10, y: 0)?.string)
        XCTAssertEqual(dr.appendAndReleaseIfCan(x: 0, y: 0)?.string, "dr")

        XCTAssertNil(dr.appendAndReleaseIfCan(x: -10, y: 0)?.string)
        XCTAssertNil(dr.appendAndReleaseIfCan(x: 10, y: 0)?.string)
        XCTAssertEqual(dr.appendAndReleaseIfCan(x: 0, y: 0)?.string, "lr")
    }
}

extension GestureTests {

    func testArrowString() {

        let ud = Gesture(fromString: "ud")
        XCTAssertEqual(ud.arrowString, Key.UpArrow.symbol + Key.DownArrow.symbol)

        let lr = Gesture(fromString: "lr")
        XCTAssertEqual(lr.arrowString, Key.LeftArrow.symbol + Key.RightArrow.symbol)
    }
}
