//
//  ExtensionNSBezierPath.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa


extension NSBezierPath {
    
    
    // MARK: Straight line
    
    func left(dx: CGFloat) {
        self.relativeLine(to: NSMakePoint(-1 * dx, 0))
    }
    
    func right(dx: CGFloat) {
        self.relativeLine(to: NSMakePoint(dx, 0))
    }
    
    func up(dy: CGFloat) {
        self.relativeLine(to: NSMakePoint(0, dy))
    }
    
    func down(dy: CGFloat) {
        self.relativeLine(to: NSMakePoint(0, -1 * dy))
    }
    
    
    // MARK: Arch line
    
    private func _centerPoint(radius: CGFloat, angle: CGFloat) -> NSPoint {
        
        let radian = CGFloat(M_PI) * angle / 180
        let dx = radius * cos(radian)
        let dy = radius * sin(radian)
        
        let x = self.currentPoint.x - CGFloat(dx)
        let y = self.currentPoint.y - CGFloat(dy)
        
        return NSPoint(x: x, y: y)
    }
    
    func clockwise(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        
        let center = _centerPoint(radius: radius, angle: startAngle)
        
        self.appendArc(withCenter: center, radius: radius,
                       startAngle: startAngle, endAngle: endAngle,
                       clockwise: true)
    }
    
    func counterClockwise(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        
        let center = _centerPoint(radius: radius, angle: startAngle)
        
        self.appendArc(withCenter: center, radius: radius,
                       startAngle: startAngle, endAngle: endAngle,
                       clockwise: false)
    }
}
