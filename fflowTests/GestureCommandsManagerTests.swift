//
//  GestureCommandsManagerTests.swift
//  fflow
//
//  Created by user on 2016/10/29.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow


class GestureCommandsManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
}
