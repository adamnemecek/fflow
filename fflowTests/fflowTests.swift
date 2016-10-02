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
    }
    
    func testSetting() {
        
        var setting = Setting()
        setting.reset()
        
        setting.setGesture(appName: "Google Chrome", gesture: "ur", keyCode: 124)
        setting.setGesture(appName: "Google Chrome", gesture: "ud", keyCode: 125, shift: true)
        setting.setGesture(appName: "Finder", gesture: "dr", keyCode: 123, option: true, command: true)
        
        setting = Setting()
        
        XCTAssertNil(setting.keyStrokes["Safari"])
        XCTAssertEqual(setting.keyStrokes["Google Chrome"]!["ur"]!, "key code 124")
        XCTAssertEqual(setting.keyStrokes["Google Chrome"]!["ud"]!, "key code 125 using {shift down}")
        XCTAssertEqual(setting.keyStrokes["Finder"]!["dr"]!, "key code 123 using {option down,command down}")
        
        setting.reset()
    }
    
    func testGestureManager() {
        
        let gm = GestureManager()
        
        XCTAssertEqual(gm.add(direction: "d"), nil)
        XCTAssertEqual(gm.add(direction: "r"), nil)
        XCTAssertEqual(gm.add(direction: nil), "dr")
        
        XCTAssertEqual(gm.add(direction: "u"), nil)
        XCTAssertEqual(gm.add(direction: "v"), nil)
        XCTAssertEqual(gm.add(direction: "l"), nil)
        XCTAssertEqual(gm.add(direction: "v"), nil)
        XCTAssertEqual(gm.add(direction: nil), "ul")
        
        XCTAssertEqual(gm.add(direction: "d"), nil)
        XCTAssertEqual(gm.add(direction: "r"), nil)
        XCTAssertEqual(gm.add(direction: "r"), nil)
        XCTAssertEqual(gm.add(direction: nil), "dr")
        
        XCTAssertEqual(gm.add(direction: "d"), nil)
        XCTAssertEqual(gm.add(direction: "r"), nil)
        XCTAssertEqual(gm.add(direction: "u"), nil)
        XCTAssertEqual(gm.add(direction: nil), "dru")
        XCTAssertEqual(gm.add(direction: "d"), nil)
        XCTAssertEqual(gm.add(direction: "r"), nil)
        XCTAssertEqual(gm.add(direction: nil), "dr")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
