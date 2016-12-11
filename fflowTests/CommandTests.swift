//
//  CommandTests.swift
//  fflow
//
//  Created by user on 2016/12/12.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class CommandTests: XCTestCase {

    let commandPreference = CommandPreference()

    let shift = Key.Shift.symbol
    let control = Key.Control.symbol
    let option = Key.Option.symbol
    let command = Key.Command.symbol

    override func setUp() {

        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        commandPreference.clearCompletely()
    }

    override func tearDown() {

        // Put teardown code here. This method is called after the invocation of each test method in the class.

        commandPreference.clearCompletely()

        super.tearDown()
    }

    func testInit() {

        let dr = Gesture(fromString: "dr")
        let cmdR = Keystroke(keyCode: 15, command: true)!

        let drCmdR = Command(gesture: dr, keystroke: cmdR)
        
        XCTAssertEqual(drCmdR.gestureString, "dr")
        XCTAssertEqual(drCmdR.keystrokeString, command + "R")
    }

    func testInitWithString() {

        let drdrOptU = Command(gestureString: "drdr", keystrokeString: option + "u")!
        
        XCTAssertEqual(drdrOptU.gestureString, "drdr")
        XCTAssertEqual(drdrOptU.keystrokeString, option + "U")
    }
}
