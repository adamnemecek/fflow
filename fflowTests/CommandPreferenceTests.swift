//
//  CommandsManagerTests.swift
//  fflow
//
//  Created by user on 2016/10/29.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class CommandPreferenceTests: XCTestCase {

    static let suiteName = "CommandPreferenceTests"

    var commandPreference = CommandPreference(suiteName: CommandPreferenceTests.suiteName)

    let safari = "/Applications/Safari.app"
    let atom = "/Applications/Atom.app"

    let shift = Key.Shift.symbol
    let control = Key.Control.symbol
    let option = Key.Option.symbol
    let command = Key.Command.symbol

    override func setUp() {

        super.setUp()

        commandPreference.clearCompletely()
        commandPreference = CommandPreference(suiteName: CommandPreferenceTests.suiteName)
    }

    override func tearDown() {

        commandPreference.clearCompletely()

        super.tearDown()
    }

    func testSet() {

        var appPaths: [String]

        let dr = "DR"
        let optionP = option + "P"

        appPaths = commandPreference.appPaths
        XCTAssertEqual(appPaths.count, 0)

        commandPreference.set(forApp: safari, gestureString: dr, keystrokeString: optionP)

        appPaths = commandPreference.appPaths
        XCTAssertEqual(appPaths.count, 1)

        commandPreference.set(forApp: atom, gestureString: dr, keystrokeString: optionP)
        commandPreference.set(forApp: atom, gestureString: "UL", keystrokeString: command + "D")

        appPaths = commandPreference.appPaths
        XCTAssertEqual(appPaths.count, 2)
    }

    func testAppPaths() {

        testSet()
        XCTAssertEqual(commandPreference.appPaths.count, 2)
    }

    func testGestures() {

        testSet()
        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 2)
    }

    func testKeystroke() {

        self.testSet()

        let optionP = commandPreference.keystroke(forApp: atom, gestureString: "DR")
        XCTAssertEqual(optionP, option + "P")

        let url = URL(fileURLWithPath: atom)
        let ul = Gesture(string: "UL")

        let commandD = commandPreference.keystroke(forApp: url, gesture: ul)
        XCTAssertEqual(commandD, command + "D")

        let uld = Gesture(string: "ULD")
        let maybeNil = commandPreference.keystroke(forApp: url, gesture: uld)
        XCTAssertNil(maybeNil)
    }

    func testRemoveKeystroke() {

        testSet()

        commandPreference.removeKeystroke(forApp: atom, gestureString: "DR")
        XCTAssertNil(commandPreference.keystroke(forApp: atom, gestureString: "DR"))
    }

    func testRemoveGesture() {

        testSet()

        let optionP = commandPreference.keystroke(forApp: atom, gestureString: "DR")
        XCTAssertEqual(optionP, option + "P")

        commandPreference.removeGesture(forApp: atom, gestureString: "DR")
        let maybeNil = commandPreference.keystroke(forApp: atom, gestureString: "DR")
        XCTAssertNil(maybeNil)
    }

    func testRemoveApp() {

        testSet()

        commandPreference.removeApp(path: atom)
        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 1)
    }

    func testClearCompletely() {

        testSet()

        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 2)
        XCTAssertEqual(commandPreference.appPaths.count, 2)

        commandPreference.clearCompletely()

        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 0)
    }
}

extension CommandPreferenceTests {

    func testEmptyKeystrokeString() {

        commandPreference.set(forApp: atom, gestureString: "DUD", keystrokeString: "")
        XCTAssertEqual(commandPreference.keystroke(forApp: atom, gestureString: "DUD"), "")
    }
}

extension CommandPreferenceTests {

    func testSetApp() {

        XCTAssertFalse(commandPreference.appPaths.contains(safari))

        commandPreference.setApp(path: safari)
        XCTAssertTrue(commandPreference.appPaths.contains(safari))
    }
}
