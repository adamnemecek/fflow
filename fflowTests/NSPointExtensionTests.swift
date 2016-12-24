//
//  NSPointExtensionTests.swift
//  fflow
//
//  Created by user on 2016/12/23.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class NSPointExtensionTests: XCTestCase {

    func testInitByBoth() {

        let point = NSPoint(bothXY: 5)

        XCTAssertEqual(point.x, 5)
        XCTAssertEqual(point.y, 5)
    }
}
