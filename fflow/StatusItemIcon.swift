//
//  StatusItemIcon.swift
//  fflow
//
//  Created by user on 2017/07/14.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

struct StatusItemIcon {

    static private let size = NSSize(width: 18, height: 18)

    static private func f() -> NSBezierPath {

        let fHeight = self.size.height * 0.75
        let crossBarAltitude = fHeight * 0.65
        let halfOfCrossBarLength = fHeight * 0.5 / 2
        let lineWidth = fHeight * 0.14
        let halfOfLineWidth = lineWidth / 2

        let f = NSBezierPath()
        f.move(to: NSPoint(x: 0, y: 0))

        f.up(dy: crossBarAltitude - halfOfLineWidth)
        f.left(dx: halfOfCrossBarLength - halfOfLineWidth)
        f.up(dy: lineWidth)
        f.right(dx: halfOfCrossBarLength - halfOfLineWidth)

        let outerRadius = lineWidth + halfOfCrossBarLength - halfOfLineWidth
        f.clockwise(radius: outerRadius, startAngle: 180, endAngle: 0)
        f.left(dx: lineWidth)
        let innerRadius = outerRadius - lineWidth
        f.counterClockwise(radius: innerRadius, startAngle: 0, endAngle: 180)

        f.right(dx: halfOfCrossBarLength - halfOfLineWidth)
        f.down(dy: lineWidth)
        f.left(dx: halfOfCrossBarLength - halfOfLineWidth)
        f.down(dy: crossBarAltitude - halfOfLineWidth)
        f.close()

        return f
    }

    static func icon() -> NSImage {

        let rect = NSRect(origin: .zero, size: self.size)
        let oval = NSBezierPath(ovalIn: rect)

        let fPath = self.f()
        let shiftRight = AffineTransform(translationByX: size.width / 4, byY: 0)
        fPath.transform(using: shiftRight)
        oval.append(fPath)

        let ovalClip = NSBezierPath(ovalIn: rect)
        let image = NSImage(size: size)
        image.lockFocus()
        ovalClip.addClip()
        NSColor.black.setFill()
        oval.fill()
        image.unlockFocus()

        image.isTemplate = true

        return image
    }
}
