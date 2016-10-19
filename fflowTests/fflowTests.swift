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
    
    func testKey() {
        
        var key: Key
        key = Key(fromCode: 3)!
        XCTAssertEqual(key.code, 3)
        XCTAssertEqual(key.symbol, "F")
        XCTAssertEqual(key.name, "F")
        
    }
    
    func testKeyStroke() {
        
        var keystroke: Keystroke
        
        XCTAssertNil(Keystroke(fromString: ""))
        
        keystroke = Keystroke(keyName: "d", command: true)!
        XCTAssertEqual(keystroke.toString(), "command-D")
        
        keystroke = Keystroke(keySymbol: "9", shift: true, command: true)!
        XCTAssertEqual(keystroke.toString(), "shift-command-9")
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
        
        let cmdW = Keystroke(keyCode: 13, command: true)! // command-w
        let dr = Gesture(fromString: "dr")
        let drCmdW = GestureCommand(gesture: dr, keystroke: cmdW)
        XCTAssertEqual(drCmdW.gestureString, dr.toString())
        XCTAssertEqual(drCmdW.keystrokeString, cmdW.toString())
        
        let drdrOptU = GestureCommand(gestureString: "drdr", keystrokeString: "option-u")!
        XCTAssertEqual(drdrOptU.gestureString, "drdr")
        XCTAssertEqual(drdrOptU.keystrokeString, "option-U")
    }
    
    func testGestureCommandsForApp() {
        
        let cmdR = Keystroke(keyCode: 15, command: true)! // command-r
        let ud = Gesture(fromString: "ud")
        let udCmdR = GestureCommand(gesture: ud, keystroke: cmdR)
        
        let gestureCommandsForApp = GestureCommandsForApp(appName: "Finder")
        gestureCommandsForApp.append(gestureCommand: udCmdR)
        gestureCommandsForApp.append(gestureString: "lr", keystrokeString: "command-t")
        XCTAssertEqual(gestureCommandsForApp.serialize(), ["ud": "command-R", "lr": "command-T"])
        
        let udCommand = gestureCommandsForApp.getGestureCommand(gesture: ud)
        XCTAssertEqual(udCommand?.gesture.toString(), ud.toString())
        XCTAssertEqual(udCommand?.gestureString, ud.toString())
        XCTAssertEqual(udCommand?.keystroke.toString(), cmdR.toString())
        
        let lrCommand = gestureCommandsForApp.getGestureCommand(gestureString: "lr")
        XCTAssertEqual(lrCommand?.gesture.toString(), "lr")
        XCTAssertEqual(lrCommand?.gestureString, "lr")
        XCTAssertEqual(lrCommand?.keystroke.toString(), "command-T")
    }
    
    func testGestureCommandsManager() {
        
        let gestureCommandsManager = GestureCommandsManager()
        let gestureCommand = GestureCommand(gestureString: "lurd", keystrokeString: "shift-t")!
        gestureCommandsManager.append(appName: "Finder", gestureCommand: gestureCommand)
        gestureCommandsManager.append(appName: "Finder", gestureString: "ur", keystrokeString: "shift-t")
        
        XCTAssertEqual(gestureCommandsManager.getKeystroke(appName: "Finder", gesture: gestureCommand.gesture)?.toString(), "shift-T")
        XCTAssertEqual(gestureCommandsManager.getKeystroke(appName: "Finder", gestureString: "ur")?.toString(), "shift-T")
        
        let serialized = gestureCommandsManager.serialize()
        XCTAssertEqual(serialized["Finder"]!, ["ur": "shift-T", "lurd": "shift-T"])
    }
    
    func testPreference() {
        
        let preference: Preference = Preference()
        let gestureCommandsManager = preference.gestureCommandsManager
        XCTAssertNil(gestureCommandsManager.getKeystroke(appName: "Finder", gestureString: "ur"))
        gestureCommandsManager.append(appName: "Finder", gestureString: "ur", keystrokeString: "command-d")
        XCTAssertEqual(gestureCommandsManager.getKeystroke(appName: "Finder", gestureString: "ur")?.toString(), "command-D")
        preference.save()
        
        let preference2: Preference = Preference()
        XCTAssertEqual(preference2.gestureCommandsManager.getKeystroke(appName: "Finder", gestureString: "ur")?.toString(), "command-D")
        preference2.clear()
    }
    
    // TODO: Add new feature: On triggering gesture, show overlay sign of the gesture.
    // TODO: Implements preference window.
    // TODO: Rename: GestureCommandsManager -> GestureCommandPreference (and then, inherits Preference class)
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
