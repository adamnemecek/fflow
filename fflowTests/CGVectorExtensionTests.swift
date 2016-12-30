//
//  CGVector.swift
//  fflow
//
//  Created by user on 2016/12/21.
//  Copyright © 2016年 user. All rights reserved.
//

import XCTest
@testable import fflow

class CGVectorExtensionTests: XCTestCase {

    func testPlusOperator() {

        let twoThree = CGVector(dx: 2, dy: 3)
        let fourFive = CGVector(dx: 4, dy: 5)

        let sixEight = twoThree + fourFive
        XCTAssertEqual(sixEight.dx, 6)
        XCTAssertEqual(sixEight.dy, 8)
    }

    func testMinusOperator() {

        let fourFive = CGVector(dx: 4, dy: 5)
        let threeTwo = CGVector(dx: 3, dy: 2)

        let oneThree = fourFive - threeTwo
        XCTAssertEqual(oneThree.dx, 1)
        XCTAssertEqual(oneThree.dy, 3)
    }

    func testMultiOperator() {

        let fourFive = CGVector(dx: 4, dy: 5)

        let twelveFifteen = 3 * fourFive
        XCTAssertEqual(twelveFifteen.dx, 12)
        XCTAssertEqual(twelveFifteen.dy, 15)
    }
}

extension CGVectorExtensionTests {

    func testInitByNSPoint() {

        let point = NSPoint(x: 2, y: 3)
        let vector = CGVector(endPoint: point)
        
        XCTAssertEqual(vector.dx, 2)
        XCTAssertEqual(vector.dy, 3)
    }
    
    func testEndPoint() {

        let fourFive = CGVector(dx: 4, dy: 5).endPoint

        XCTAssertEqual(fourFive.x, 4)
        XCTAssertEqual(fourFive.y, 5)
    }
}
