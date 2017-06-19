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

        XCTAssertNil(Keystroke(fromString: ""))
        XCTAssertNotNil(Keystroke(fromString: "a"))
        XCTAssertNotNil(Keystroke(fromString: "A"))
        XCTAssertNotNil(Keystroke(fromString: control + "A"))
        XCTAssertNotNil(Keystroke(fromString: shift + "A"))
        XCTAssertNotNil(Keystroke(fromString: option + "A"))
        XCTAssertNotNil(Keystroke(fromString: command + "A"))
        XCTAssertNotNil(Keystroke(fromString: option + command + "A"))

        XCTAssertNotNil(Keystroke(keyName: "zero"))
        XCTAssertNotNil(Keystroke(keyName: "Zero"))
        XCTAssertNotNil(Keystroke(keyName: "Zero", control: true, option: true, shift: true, command: true))

        XCTAssertNotNil(Keystroke(keySymbol: "→"))
        XCTAssertNotNil(Keystroke(keySymbol: "→", control: true, option: true, shift: true, command: true))

        XCTAssertNotNil(Keystroke(keyCode: 34))
        XCTAssertNotNil(Keystroke(keyCode: 34, control: true, option: true, shift: true, command: true))
    }

    func testString() {

        let controlA = Keystroke(fromString: control + "A")
        XCTAssertEqual(controlA?.string, control + "A")

        let F8 = Keystroke(fromString: command + "F8")
        XCTAssertEqual(F8?.string, command + "F8")

        let u = Keystroke(keyName: "u")
        XCTAssertEqual(u?.string, "U")

        let commandD = Keystroke(keyName: "d", command: true)
        XCTAssertEqual(commandD?.string, "⌘D")

        let optionY = Keystroke(keyName: "y", option: true)
        XCTAssertEqual(optionY?.string, "⌥Y")

        let shiftCommand9 = Keystroke(keySymbol: "9", shift: true, command: true)
        XCTAssertEqual(shiftCommand9?.string, "⇧⌘9")

        let control9 = Keystroke(keyCode: 10, control: true)
        XCTAssertEqual(control9?.string, "⌃§")
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

extension KeystrokeTests {

    func testModifiersOrder() {

        // correct order: control, option, shift, command

        let coscA = Keystroke(fromString: control + option + shift + command + "a")
        XCTAssertEqual(coscA?.string, control + option + shift + command + "A")

        let controlShiftB = Keystroke(fromString: control + shift + "z")
        XCTAssertEqual(controlShiftB?.string, control + shift + "Z")
        let keystrokeNil = Keystroke(fromString: shift + control + "z")
        XCTAssertNil(keystrokeNil)
    }
}

extension KeystrokeTests {

    func testEventModifierFlags() {

        let flags: NSEventModifierFlags = [.option, .control, .command, .shift]
        let coscF2 = Keystroke(keyCode: 120, modifierFlags: flags)
        XCTAssertEqual(coscF2?.string, control + option + shift + command + "F2")
    }
}
