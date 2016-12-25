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

    let userDefaults = NSUserDefaultsController().defaults

    let commandPreference = CommandPreference()

    let Safari = "/Applications/Safari.app"
    let Atom = "/Applications/Atom.app"

    let shift = Key.Shift.symbol
    let control = Key.Control.symbol
    let option = Key.Option.symbol
    let command = Key.Command.symbol
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Preference().clearCompletely()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Preference().clearCompletely()
        super.tearDown()
    }

    func testSet() {

        var appPaths: [Any]?

        let dr = "dr"
        let optionP = option + "p"

        commandPreference.set(forApp: Safari, gestureString: dr, keystrokeString: optionP)

        appPaths = userDefaults.array(forKey: "appPaths")
        XCTAssertEqual(appPaths?.count, 1)
        XCTAssertEqual(appPaths?[0] as? String, Safari)

        commandPreference.set(forApp: Atom, gestureString: dr, keystrokeString: optionP)
        commandPreference.set(forApp: Atom, gestureString: "ul", keystrokeString: command + "d")

        appPaths = userDefaults.array(forKey: "appPaths")
        XCTAssertEqual(appPaths?.count, 2)
        XCTAssertEqual(appPaths?[1] as? String, Atom)
    }

    func testAppPaths() {

        testSet()
        XCTAssertEqual(commandPreference.appPaths.count, 2)
    }

    func testGestures() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 2)
    }

    func testKeystrokes() {

        self.testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)
    }

    func testKeystroke() {

        self.testSet()
        let optionP = commandPreference.keystroke(forApp: Atom, gestureString: "dr")
        XCTAssertEqual(optionP, option + "p")
    }

    func testRemoveKeystroke() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        commandPreference.removeKeystroke(forApp: Atom, gestureString: "dr")
        XCTAssertNil(commandPreference.keystroke(forApp: Atom, gestureString: "dr"))

        let keystrokes = commandPreference.keystrokes(forApp: Atom)
        XCTAssertEqual(keystrokes[0], "")
        XCTAssertEqual(keystrokes[1], command + "d")
    }

    func testRemoveGesture() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        commandPreference.removeGesture(forApp: Atom, gestureString: "dr")
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 1)
    }
    
    func testRemoveGestures() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        commandPreference.removeGestures(forApp: Atom)
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 0)
    }

    func testRemoveApp() {

        testSet()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        commandPreference.removeApp(path: Atom)
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 1)
    }

    func testClearCompletely() {

        testSet()

        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 2)
        XCTAssertEqual(commandPreference.appPaths.count, 2)

        commandPreference.clearCompletely()
        
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 0)
    }
}
