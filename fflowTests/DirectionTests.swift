//
//  DirectionTests.swift
//  fflow
//
//  Created by user on 2016/12/11.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class DirectionTests: XCTestCase {

    override func setUp() {

        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFilter() {
        
        XCTAssertEqual(Direction.filter(string: "iuydl rpre"), "udlrr")
    }
    
    func testWhich() {

        XCTAssertEqual(Direction.which(x: 0.0, y: 0.0), .No)
        XCTAssertEqual(Direction.which(x: 1.0, y: 1.0), .Vague)
        XCTAssertEqual(Direction.which(x: 0.0, y: -5.0), .Up)
        XCTAssertEqual(Direction.which(x: 0.0, y: 5.0), .Down)
        XCTAssertEqual(Direction.which(x: -3.0, y: 0.0), .Left)
        XCTAssertEqual(Direction.which(x: 3.0, y: 0.0), .Right)
    }
    
    
    func testIsNo() {
        
        XCTAssertTrue(Direction.No.isNo)
        XCTAssertFalse(Direction.Up.isNo)
    }
    func testIsVague() {
        
        XCTAssertTrue(Direction.Vague.isVague)
        XCTAssertFalse(Direction.Up.isVague)
    }
    
    func testUnitVector() {
        
        let upUnitVector = Direction.Up.unitVector
        XCTAssertEqual(upUnitVector.x, 0)
        XCTAssertEqual(upUnitVector.y, 1)

        let downUnitVector = Direction.Down.unitVector
        XCTAssertEqual(downUnitVector.x, 0)
        XCTAssertEqual(downUnitVector.y, -1)
        
        let leftUnitVector = Direction.Left.unitVector
        XCTAssertEqual(leftUnitVector.x, -1)
        XCTAssertEqual(leftUnitVector.y, 0)
        
        let rightUnitVector = Direction.Right.unitVector
        XCTAssertEqual(rightUnitVector.x, 1)
        XCTAssertEqual(rightUnitVector.y, 0)
    }
}
