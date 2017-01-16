//
//  CGVector.extension.swift
//  fflow
//
//  Created by user on 2016/12/21.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

extension CGVector {

    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {

        return CGVector(dx: lhs.dx + rhs.dx,
                        dy: lhs.dy + rhs.dy)
    }

    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {

        return CGVector(dx: lhs.dx - rhs.dx,
                        dy: lhs.dy - rhs.dy)
    }

    static func * (lhs: CGFloat, rhs: CGVector) -> CGVector {

        return CGVector(dx: lhs * rhs.dx,
                        dy: lhs * rhs.dy)
    }
}

extension CGVector {

    init(endPoint: NSPoint) {

        self.init(dx: endPoint.x, dy: endPoint.y)
    }

    var endPoint: NSPoint {

        return NSPoint(x: self.dx, y: self.dy)
    }
}
