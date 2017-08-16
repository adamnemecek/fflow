//
//  NSEventModifierFlagsExtensionTests.swift
//  fflow
//
//  Created by user on 2017/08/16.
//  Copyright © 2017年 user. All rights reserved.
//

import XCTest
@testable import fflow

class NSEventModifierFlagsExtensionTests: XCTestCase {

    func testCGEventFlags() {

        let nsFlags: NSEventModifierFlags = [.control]
        let cgFlags: CGEventFlags = nsFlags.cgEventFlags

        XCTAssertTrue(cgFlags.contains(.maskControl))
    }
}
