//
//  NSScreenExtensionTests.swift
//  fflow
//
//  Created by user on 2017/06/18.
//  Copyright © 2017年 user. All rights reserved.
//

import XCTest
@testable import fflow

class NSScreenExtensionTests: XCTestCase {

    func testMousePointed() {

        guard let screenFrame = NSScreen.mousePointed()?.frame else { return }
        let mouse = NSEvent.mouseLocation()

        XCTAssertTrue(screenFrame.contains(mouse))
    }
}
