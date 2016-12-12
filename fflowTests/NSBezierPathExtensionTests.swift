//
//  NSBezierPathExtension.swift
//  fflow
//
//  Created by user on 2016/12/12.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
//
//  NSBezierPathExtensionTests.swift
//  fflow
//
//  Created by user on 2016/12/11.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class NSBezierPathExtensionTests: XCTestCase {

    override func setUp() {

        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUpDownLeftRight() {

        let bezierPath = NSBezierPath()
        bezierPath.move(to: NSPoint(x: 0, y: 0))

        bezierPath.up(dy: 10)
        XCTAssertEqual(bezierPath.currentPoint.x, 0)
        XCTAssertEqual(bezierPath.currentPoint.y, 10)

        bezierPath.left(dx: 20)
        XCTAssertEqual(bezierPath.currentPoint.x, -20)
        XCTAssertEqual(bezierPath.currentPoint.y, 10)

        bezierPath.down(dy: 50)
        XCTAssertEqual(bezierPath.currentPoint.x, -20)
        XCTAssertEqual(bezierPath.currentPoint.y, -40)
        
        bezierPath.right(dx: 100)
        XCTAssertEqual(bezierPath.currentPoint.x, 80)
        XCTAssertEqual(bezierPath.currentPoint.y, -40)
    }

    func testClockwise() {

        let bezierPath = NSBezierPath()

        bezierPath.move(to: NSPoint(x: 0, y: 0))
        bezierPath.clockwise(radius: 100, startAngle: 0, endAngle: -90)
        XCTAssertEqual(bezierPath.currentPoint.x, -100)
        XCTAssertEqual(bezierPath.currentPoint.y, -100)

        bezierPath.move(to: NSPoint(x: 0, y: 0))
        bezierPath.counterClockwise(radius: 150, startAngle: 0, endAngle: 90)
        XCTAssertEqual(bezierPath.currentPoint.x, -150)
        XCTAssertEqual(bezierPath.currentPoint.y, 150)
    }
}
