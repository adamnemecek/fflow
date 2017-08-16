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

    var suiteName: String { return "KeystrokeTests" }
    var key: String { return "Key" }

    func testSerialize() {

        guard let defaults = UserDefaults(suiteName: self.suiteName) else { return }

        let shiftX = Keystroke(key: .X, modifierFlags: [.maskShift])
        defaults.set(shiftX.serialized(), forKey: self.key)

        let serialized = defaults.dictionary(forKey: self.key) as? [String: UInt16]
        XCTAssertEqual(serialized?["keyCode"], 7)
        XCTAssertEqual(serialized?["control"], 0)
        XCTAssertEqual(serialized?["option"], 0)
        XCTAssertEqual(serialized?["shift"], 1)
        XCTAssertEqual(serialized?["command"], 0)

        defaults.removeSuite(named: self.suiteName)
    }

    func testDeserialize() {

        guard let defaults = UserDefaults(suiteName: self.suiteName) else { return }

        let shiftX = Keystroke(key: .X, modifierFlags: [.maskShift])
        defaults.set(shiftX.serialized(), forKey: self.key)

        let serialized = defaults.dictionary(forKey: self.key) as? [String: UInt16]
        let deserialized = Keystroke(serialized: serialized)

        XCTAssertEqual(deserialized?.key.code, 7)
        XCTAssertEqual(deserialized?.modifierFlags.contains(.maskShift), true)

        defaults.removeSuite(named: self.suiteName)
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
