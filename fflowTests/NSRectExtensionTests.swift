//
//  NSRect.extension.swift
//  fflow
//
//  Created by user on 2016/12/21.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class NSRectExtensionTests: XCTestCase {

    func testInitWithSize() {

        let rect = NSRect(size: .init(width: 20, height: 30))

        XCTAssertEqual(rect.origin.x, 0)
        XCTAssertEqual(rect.origin.y, 0)
        XCTAssertEqual(rect.size.width, 20)
        XCTAssertEqual(rect.size.height, 30)
    }

    func testInitWithWidthAndHeight() {

        let rect = NSRect(width: 22, height: 33)

        XCTAssertEqual(rect.origin.x, 0)
        XCTAssertEqual(rect.origin.y, 0)
        XCTAssertEqual(rect.size.width, 22)
        XCTAssertEqual(rect.size.height, 33)
    }

    func testShortSideAndLongSide() {

        let rect = NSRect(width: 22, height: 33)

        XCTAssertEqual(rect.shortSide, 22)
        XCTAssertEqual(rect.longSide, 33)
    }
}

extension NSRectExtensionTests {

    func testInitWithCenter() {

        let center = NSPoint(x: 30, y: 40)
        let size = NSSize(squaringOf: 50)
        let rect = NSRect(center: center, size: size)

        XCTAssertEqual(rect.origin.x, 5)
        XCTAssertEqual(rect.origin.y, 15)
        XCTAssertEqual(rect.size.width, 50)
        XCTAssertEqual(rect.size.height, 50)
    }

    func testCenterPoint() {

        let centerPoint = NSRect(x: 3, y: 4, width: 5, height: 6).centerPoint

        XCTAssertEqual(centerPoint.x, 5.5)
        XCTAssertEqual(centerPoint.y, 7)
    }
}
