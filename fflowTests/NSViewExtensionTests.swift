//
//  NSViewExtensionTests.swift
//  fflow
//
//  Created by user on 2016/12/22.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class NSViewExtensionTests: XCTestCase {

    func testInitBySize() {

        let view = NSView(size: .init(width: 3, height: 4))
        let frame = view.frame

        let origin = frame.origin
        let size = frame.size
        XCTAssertEqual(origin.x, 0)
        XCTAssertEqual(origin.y, 0)
        XCTAssertEqual(size.width, 3)
        XCTAssertEqual(size.height, 4)
    }
}
