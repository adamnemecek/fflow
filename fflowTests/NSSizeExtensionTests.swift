//
//  NSSizeExtensionTests.swift
//  fflow
//
//  Created by user on 2016/12/22.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class NSSizeExtensionTests: XCTestCase {

    func testShortSideAndLongSide() {

        let size = NSSize(width: 4, height: 5)
        XCTAssertEqual(size.shortSide, 4)
        XCTAssertEqual(size.longSide, 5)
    }
    
    func testInitSquare() {

        let square = NSSize(squaringOf: 4)
        XCTAssertEqual(square.width, 4)
        XCTAssertEqual(square.height, 4)
    }

    func testInsetBy() {

        let size = NSSize(width: 200, height: 100).insetBy(dx: 20, dy: 10)

        XCTAssertEqual(size.width, 160)
        XCTAssertEqual(size.height, 80)
    }
}
