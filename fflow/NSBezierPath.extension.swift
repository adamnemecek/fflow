//
//  NSBezierPath.extension.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa


extension NSBezierPath {
    
    func left(dx: CGFloat) {

        self.relativeLine(to: .init(x: -dx, y: 0))
    }
    
    func right(dx: CGFloat) {

        self.relativeLine(to: .init(x: dx, y: 0))
    }
    
    func up(dy: CGFloat) {

        self.relativeLine(to: .init(x: 0, y: dy))
    }

    func down(dy: CGFloat) {

        self.relativeLine(to: .init(x: 0, y: -dy))
    }

    private func pointOfCenter(radius: CGFloat, angle: CGFloat) -> NSPoint {

        let currentVector = CGVector(endPoint: self.currentPoint)
        let radian = M_PI * Double(angle) / 180
        let radiusVector = radius * CGVector(dx: cos(radian), dy: sin(radian))

        let centerVector = currentVector - radiusVector

        return centerVector.endPoint
    }
    
    func clockwise(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        
        self.appendArc(withCenter: pointOfCenter(radius: radius, angle: startAngle),
                       radius: radius,
                       startAngle: startAngle,
                       endAngle: endAngle,
                       clockwise: true)
    }
    
    func counterClockwise(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        
        self.appendArc(withCenter: pointOfCenter(radius: radius, angle: startAngle),
                       radius: radius,
                       startAngle: startAngle,
                       endAngle: endAngle,
                       clockwise: false)
    }
}
