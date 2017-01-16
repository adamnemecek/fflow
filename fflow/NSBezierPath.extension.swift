//
//  NSBezierPath.extension.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

extension NSBezierPath {

    func left(dx deltaX: CGFloat) {

        self.relativeLine(to: .init(x: -deltaX, y: 0))
    }

    func right(dx deltaX: CGFloat) {

        self.relativeLine(to: .init(x: deltaX, y: 0))
    }

    func up(dy deltaY: CGFloat) {

        self.relativeLine(to: .init(x: 0, y: deltaY))
    }

    func down(dy deltaY: CGFloat) {

        self.relativeLine(to: .init(x: 0, y: -deltaY))
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

extension NSBezierPath {

    func scaleBounds(within limitSize: NSSize) {

        let limit = limitSize.shortSide
        let longSide = self.bounds.longSide
        self.transform(using: .init(scale: limit / longSide))
    }

    func setBoundsCenter(of frame: NSRect) {

        let from = self.bounds.centerPoint
        let to = frame.centerPoint
        let dx = to.x - from.x
        let dy = to.y - from.y

        self.transform(using: .init(translationByX: dx, byY: dy))
    }
}

extension NSBezierPath {

    convenience init(initialPoint: NSPoint) {

        self.init()
        self.move(to: initialPoint)
    }

    convenience init(initialX: CGFloat, y initialY: CGFloat) {

        self.init(initialPoint: .init(x: initialX, y: initialY))
    }
}
