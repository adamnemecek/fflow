//
//  AppColumnTest.swift
//  fflow
//
//  Created by user on 2017/04/18.
//  Copyright © 2017年 user. All rights reserved.
//

import XCTest
@testable import fflow

class AppColumnTests: XCTestCase {

    func testPath() {

        XCTAssertEqual(AppColumn.path(at: 0), "/")
        XCTAssertEqual(AppColumn.path(at: 1), "/System/Library/CoreServices/Finder.app")
    }
}
