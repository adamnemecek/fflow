//
//  CGFloatExtensionTests.swift
//  fflow
//
//  Created by user on 2016/12/29.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class CGFloatExtensionTests: XCTestCase {

    func testPowerOperator() {

        let f: CGFloat = 3

        XCTAssertEqual(f ** 2, 9)
        XCTAssertEqual(f ** 3, 27)
        XCTAssertEqual(f ** 4, 81)
        
        XCTAssertEqual(f ** 2 + f ** 3, 36)

        XCTAssertEqual(f ** 2 * f ** 3, 243)
    }
}
