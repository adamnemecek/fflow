//
//  fflowTests.swift
//  fflowTests
//
//  Created by user on 2016/09/30.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class fflowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDirection() {
        
        XCTAssertEqual(Direction.which(0.0, y: 0.0), nil)
        XCTAssertEqual(Direction.which(1.0, y: 1.0), .Vague)
        XCTAssertEqual(Direction.which(0.0, y: -5.0), .Up)
        XCTAssertEqual(Direction.which(0.0, y: 5.0), .Down)
        XCTAssertEqual(Direction.which(-3.0, y: 0.0), .Left)
        XCTAssertEqual(Direction.which(3.0, y: 0.0), .Right)
        
        XCTAssertEqual(Direction.Vague.isVague(), true)
        
        XCTAssertEqual(Direction.filter(targetString: "iuydl rpre"), "udlrr")
    }
    
    func testKeyStroke() {
        
        let keyStroke = Keystroke(keyCode: 43, command: true)
        XCTAssertEqual(keyStroke.keyCode, 43)
        XCTAssertEqual(keyStroke.modifierKeys, ["command"])
        
        let keyStroke2 = Keystroke(keyCode: 124, shift: true, command: true)
        XCTAssertEqual(keyStroke2.keyCode, 124)
        XCTAssertEqual(keyStroke2.modifierKeys, ["shift", "command"])
        XCTAssertEqual(keyStroke2.toString(), "shift-command-124")
    }
    
    func testGesture() {
        
        let gesture = Gesture()
        
        XCTAssertEqual(gesture.count, 0)
        XCTAssertEqual(gesture.last, nil)
        XCTAssertEqual(gesture.toString(), "")
        XCTAssertEqual(gesture.copy().toString(), "")
        
        gesture.clear()
        XCTAssertEqual(gesture.toString(), "")
        
        gesture.append(direction: Direction.Down)
        XCTAssertEqual(gesture.toString(), "d")
        
        gesture.append(direction: Direction.Down)
        gesture.append(direction: Direction.Up)
        gesture.append(direction: Direction.Left)
        XCTAssertEqual(gesture.toString(), "ddul")
        XCTAssertEqual(gesture.last, .Left)
        XCTAssertEqual(gesture.count, 4)
        
        let copied = gesture.copy()
        gesture.clear()
        XCTAssertEqual(copied.toString(), "ddul")
        XCTAssertEqual(gesture.toString(), "")
        
        XCTAssertEqual(Gesture(fromString: "ud").toString(), "ud")
    }
    
    func testGestureProcessor() {
        
        let gm = GestureProcessor()
        
        let u: Direction? = .Up
        let d: Direction? = .Down
        let l: Direction? = .Left
        let r: Direction? = .Right
        let v: Direction? = .Vague
        
        XCTAssertNil(gm.append(direction: u))
        XCTAssertNil(gm.append(direction: nil))
        
        XCTAssertNil(gm.append(direction: d))
        XCTAssertNil(gm.append(direction: r))
        XCTAssertEqual(gm.append(direction: nil)?.toString(), "dr")
        
        XCTAssertNil(gm.append(direction: u))
        XCTAssertNil(gm.append(direction: v))
        XCTAssertNil(gm.append(direction: l))
        XCTAssertNil(gm.append(direction: v))
        XCTAssertEqual(gm.append(direction: nil)?.toString(), "ul")
        
        XCTAssertNil(gm.append(direction: d))
        XCTAssertNil(gm.append(direction: r))
        XCTAssertNil(gm.append(direction: v))
        XCTAssertNil(gm.append(direction: r))
        XCTAssertNil(gm.append(direction: u))
        XCTAssertEqual(gm.append(direction: nil)?.toString(), "dru")
    }
    
    func testGestureCommand() {
        
        let cmdW = Keystroke(keyCode: 13, command: true) // command-w
        let dr = Gesture(fromString: "dr")
        let drCmdW = GestureCommand(gesture: dr, keystroke: cmdW)
        XCTAssertEqual(drCmdW.gesture.toString(), dr.toString())
        XCTAssertEqual(drCmdW.gestureString, dr.toString())
        XCTAssertEqual(drCmdW.keystroke.toString(), cmdW.toString())
    }
    
    func testGestureCommandManager() {
        
        let cmdR = Keystroke(keyCode: 15, command: true) // command-r
        let ud = Gesture(fromString: "ud")
        let udCmdR = GestureCommand(gesture: ud, keystroke: cmdR)
        
        let gestureCommandManager = GestureCommandManager()
        gestureCommandManager.append(appName: "Finder", gestureCommand: udCmdR)
        
        let keystroke = gestureCommandManager.getKeystroke(appName: "Finder", gesture: ud)
        
        XCTAssertEqual(keystroke?.toString(), cmdR.toString())
        
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
