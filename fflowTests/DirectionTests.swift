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
        
        let up = Direction.Up.unitVector
        XCTAssertEqual(up.dx, 0)
        XCTAssertEqual(up.dy, 1)

        let down = Direction.Down.unitVector
        XCTAssertEqual(down.dx, 0)
        XCTAssertEqual(down.dy, -1)
        
        let left = Direction.Left.unitVector
        XCTAssertEqual(left.dx, -1)
        XCTAssertEqual(left.dy, 0)
        
        let right = Direction.Right.unitVector
        XCTAssertEqual(right.dx, 1)
        XCTAssertEqual(right.dy, 0)
    }

    func testIsVertical() {

        let up = Direction.Up
        XCTAssertTrue(up.isVertical)
        XCTAssertFalse(up.isHorizontal)
    }

    func testIsHorizontal() {

        let left = Direction.Left
        XCTAssertTrue(left.isHorizontal)
        XCTAssertFalse(left.isVertical)
    }
}

extension DirectionTests {

    func testString() {

        XCTAssertEqual(Direction.Up.string, "u")
        XCTAssertEqual(Direction.Down.string, "d")
        XCTAssertEqual(Direction.Left.string, "l")
        XCTAssertEqual(Direction.Right.string, "r")
    }

    func testArrowString() {
        
        XCTAssertEqual(Direction.Up.arrowString, Key.UpArrow.symbol)
        XCTAssertEqual(Direction.Down.arrowString, Key.DownArrow.symbol)
        XCTAssertEqual(Direction.Left.arrowString, Key.LeftArrow.symbol)
        XCTAssertEqual(Direction.Right.arrowString, Key.RightArrow.symbol)
    }
}
