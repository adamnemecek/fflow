//
//  ValidScrollTests.swift
//  fflow
//
//  Created by user on 2017/06/19.
//  Copyright © 2017年 user. All rights reserved.
//

import XCTest
@testable import fflow

class ValidScrollTests: XCTestCase {

    func testDirection() {

        XCTAssertEqual(ValidScroll(deltaX:  0.0, deltaY:  0.0)?.direction, .No)
        XCTAssertNil(ValidScroll(deltaX:  1.0, deltaY:  1.0)?.direction)

        XCTAssertEqual(ValidScroll(deltaX:  0.0, deltaY: -5.0)?.direction, .Up)
        XCTAssertEqual(ValidScroll(deltaX:  0.0, deltaY:  5.0)?.direction, .Down)
        XCTAssertEqual(ValidScroll(deltaX: -3.0, deltaY:  0.0)?.direction, .Left)
        XCTAssertEqual(ValidScroll(deltaX:  3.0, deltaY:  0.0)?.direction, .Right)
    }
}
