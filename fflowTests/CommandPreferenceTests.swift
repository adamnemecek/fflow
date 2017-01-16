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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        commandPreference.clearCompletely()
        commandPreference = CommandPreference(suiteName: CommandPreferenceTests.suiteName)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        commandPreference.clearCompletely()
        super.tearDown()
    }

    func testSet() {

        var appPaths: [String]

        let dr = "dr"
        let optionP = option + "p"

        appPaths = commandPreference.appPaths
        XCTAssertEqual(appPaths.count, 2)
        XCTAssertEqual(appPaths[0], AppItem.Global.path)
        XCTAssertEqual(appPaths[1], AppItem.Finder.path)

        commandPreference.set(forApp: safari, gestureString: dr, keystrokeString: optionP)

        appPaths = commandPreference.appPaths
        XCTAssertEqual(appPaths.count, 3)
        XCTAssertEqual(appPaths[2], safari)

        commandPreference.set(forApp: atom, gestureString: dr, keystrokeString: optionP)
        commandPreference.set(forApp: atom, gestureString: "ul", keystrokeString: command + "d")

        appPaths = commandPreference.appPaths
        XCTAssertEqual(appPaths.count, 4)
        XCTAssertEqual(appPaths[3], atom)
    }

    func testAppPaths() {

        testSet()
        XCTAssertEqual(commandPreference.appPaths.count, 4)
    }

    func testGestures() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 2)
        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 2)
    }

    func testKeystrokes() {

        self.testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 2)
    }

    func testKeystroke() {

        self.testSet()
        let optionP = commandPreference.keystroke(forApp: atom, gestureString: "dr")
        XCTAssertEqual(optionP, option + "p")
    }

    func testRemoveKeystroke() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 2)

        commandPreference.removeKeystroke(forApp: atom, gestureString: "dr")
        XCTAssertNil(commandPreference.keystroke(forApp: atom, gestureString: "dr"))

        let keystrokes = commandPreference.keystrokes(forApp: atom)
        XCTAssertEqual(keystrokes[0], "")
        XCTAssertEqual(keystrokes[1], command + "d")
    }

    func testRemoveGesture() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 2)

        commandPreference.removeGesture(forApp: atom, gestureString: "dr")
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 1)
    }

    func testRemoveGestures() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 2)

        commandPreference.removeGestures(forApp: atom)
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 0)
    }

    func testRemoveApp() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 2)

        commandPreference.removeApp(path: atom)
        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 3)
    }

    func testClearCompletely() {

        testSet()

        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 2)
        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 2)
        XCTAssertEqual(commandPreference.appPaths.count, 4)

        commandPreference.clearCompletely()

        XCTAssertEqual(commandPreference.keystrokes(forApp: atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 0)
    }

    func testSetForGlobal() {

        commandPreference.setForGlobal(gestureString: "ud", keystrokeString: option + "U")
        commandPreference.setForGlobal(gestureString: "lr", keystrokeString: option + "R")

        XCTAssertEqual(commandPreference.appPaths.count, 2)
        XCTAssertEqual(commandPreference.appPaths[0], "/")

        XCTAssertEqual(commandPreference.gestures(forApp: "/").count, 2)
        XCTAssertEqual(commandPreference.keystrokes(forApp: "/").count, 2)
        XCTAssertEqual(commandPreference.keystroke(forApp: "/", gestureString: "ud"), option + "U")
    }

    func testKeystrokeForGlobal() {

        testSet()
        commandPreference.setForGlobal(gestureString: "ud", keystrokeString: option + "U")

        let dr = Gesture(fromString: "dr")
        XCTAssertNil(commandPreference.keystrokeForGlobal(gesture: dr))
        let ud = Gesture(fromString: "ud")
        XCTAssertEqual(commandPreference.keystrokeForGlobal(gesture: ud), option + "U")
    }
}

extension CommandPreferenceTests {

    func testEmptyKeystrokeString() {

        let dud = Gesture(fromString: "dud")
        commandPreference.setForGlobal(gestureString: "dud", keystrokeString: "")
        XCTAssertEqual(commandPreference.keystrokeForGlobal(gesture: dud), "")
    }
}

extension CommandPreferenceTests {

    func testSetApp() {

        XCTAssertFalse(commandPreference.appPaths.contains(safari))
        commandPreference.setApp(path: safari)
        XCTAssertTrue(commandPreference.appPaths.contains(safari))
    }
}
