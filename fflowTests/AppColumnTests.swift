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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPath() {

        XCTAssertEqual(AppColumn.path(at: 0), "/")
        XCTAssertEqual(AppColumn.path(at: 1), "/System/Library/CoreServices/Finder.app")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
