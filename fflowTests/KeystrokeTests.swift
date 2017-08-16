//
//  KeystrokeTests.swift
//  fflow
//
//  Created by user on 2016/12/08.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class KeystrokeTests: XCTestCase {

    let shift = Key.Shift.symbol
    let control = Key.Control.symbol
    let option = Key.Option.symbol
    let command = Key.Command.symbol

    func testInit() {

        XCTAssertNil(Keystroke(string: ""))
        XCTAssertNotNil(Keystroke(string: "a"))
        XCTAssertNotNil(Keystroke(string: "A"))
        XCTAssertNotNil(Keystroke(string: control + "A"))
        XCTAssertNotNil(Keystroke(string: shift + "A"))
        XCTAssertNotNil(Keystroke(string: option + "A"))
        XCTAssertNotNil(Keystroke(string: command + "A"))
        XCTAssertNotNil(Keystroke(string: option + command + "A"))
    }

    func testString() {

        let controlA = Keystroke(string: control + "A")
        XCTAssertEqual(controlA?.string, control + "A")

        let F8 = Keystroke(string: command + "F8")
        XCTAssertEqual(F8?.string, command + "F8")
    }
}

extension KeystrokeTests {

    // NOTE: native code is about 16x faster than which through applescript

    // Through applescript
//    func testDispatchTo() {
//
//        guard let shiftA = Keystroke(keyName: "A", shift: true) else { return }
//
//        self.measure {
//
//            for _ in 0..<500 { shiftA.dispatchTo(appName: "Atom") }
//        }
//    }

    // Native code
//    func testDispatchToFrontmostApp() {
//
//        guard let shiftA = Keystroke(keyName: "A", shift: true) else { return }
//
//        self.measure {
//
//            for _ in 0..<100 { shiftA.dispatchToFrontmostApp() }
//        }
//    }
}
