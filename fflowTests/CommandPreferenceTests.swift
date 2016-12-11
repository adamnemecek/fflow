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

        let drOptionP = Command(gestureString: "dr", keystrokeString: option + "p")!

        commandPreference.set(forApp: Safari, command: drOptionP)

        appPaths = userDefaults.array(forKey: "appPaths")
        XCTAssertEqual(appPaths?.count, 1)
        XCTAssertEqual(appPaths?[0] as? String, Safari)

        commandPreference.set(forApp: Atom, command: drOptionP)

        appPaths = userDefaults.array(forKey: "appPaths")
        XCTAssertEqual(appPaths?.count, 2)
        XCTAssertEqual(appPaths?[1] as? String, Atom)
    }

    func testAppPaths() {

        testSet()
        XCTAssertEqual(commandPreference.appPaths.count, 2)
    }

    func testGestures() {

        testKeystrokes()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 2)
    }

    func testKeystrokes() {

        let drOptionP = Command(gestureString: "dr", keystrokeString: option + "p")!
        commandPreference.set(forApp: Atom, command: drOptionP)

        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 1)
        
        let luShiftT = Command(gestureString: "lu", keystrokeString: shift + "t")!
        commandPreference.set(forApp: Atom, command: luShiftT)

        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)
    }

    func testKeystroke() {

        let drOptionP = Command(gestureString: "dr", keystrokeString: option + "p")!
        commandPreference.set(forApp: Atom, command: drOptionP)

        let optionP = commandPreference.keystroke(forApp: Atom, gestureString: drOptionP.gestureString)
        XCTAssertEqual(optionP, drOptionP.keystrokeString)
    }

    func testRemoveKeystroke() {

        testKeystrokes()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        commandPreference.removeKeystroke(forApp: Atom, gestureString: "dr")
        XCTAssertNil(commandPreference.keystroke(forApp: Atom, gestureString: "dr"))

        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2) // ["(removed)", shift + "T"]
    }

    func testRemoveGestures() {

        testKeystrokes()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        commandPreference.removeGestures(forApp: Atom)
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 0)
    }

    func testRemoveApp() {

        testKeystrokes()
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)

        commandPreference.removeApp(path: Atom)
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 0)
    }

    func testClearCompletely() {

        testKeystrokes()

        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 2)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 2)
        XCTAssertEqual(commandPreference.appPaths.count, 1)

        commandPreference.clearCompletely()
        
        XCTAssertEqual(commandPreference.keystrokes(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.gestures(forApp: Atom).count, 0)
        XCTAssertEqual(commandPreference.appPaths.count, 0)
    }
}
