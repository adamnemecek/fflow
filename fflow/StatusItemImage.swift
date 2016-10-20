//
//  StatusItemImage.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa


class StatusItemImage {
    
    private let w: CGFloat = 16
    private let h: CGFloat = 16
    
    let image: NSImage
    
    init() {
        
        let cross = NSBezierPath()
        cross.move(to: NSMakePoint(0, 0))

        cross.up(dy: 50)
        cross.left(dx: 10)
        cross.up(dy: 10)
        cross.right(dx: 10)
        cross.up(dy: 10)
        cross.right(dx: 10)
        cross.down(dy: 10)
        cross.right(dx: 10)
        cross.down(dy: 10)
        cross.left(dx: 10)
        cross.down(dy: 50)
        cross.close()

        let arc = NSBezierPath()
        arc.move(to: NSMakePoint(10, 70))
        arc.appendArc(withCenter: NSMakePoint(25, 70), radius: 15, startAngle: 180, endAngle: 360, clockwise: true)
        arc.relativeLine(to: NSMakePoint(-10, 0))
        arc.appendArc(withCenter: NSMakePoint(25, 70), radius: 5, startAngle: 0, endAngle: 180, clockwise: false)
        arc.close()

        let oval = NSBezierPath(ovalIn: NSMakeRect(0, 0, 100, 100))

        cross.transform(using: AffineTransform(translationByX: 30, byY: 0))
        arc.transform(using: AffineTransform(translationByX: 20, byY: 0))
        oval.append(cross)
        oval.append(arc)

        let ovalClip = NSBezierPath(ovalIn: NSMakeRect(0, 0, 100, 100))

        image = NSImage(size: .init(width: 100, height: 100))

        image.lockFocus()

        ovalClip.addClip()

        NSColor.black.setFill()

        oval.fill()

        image.unlockFocus()
        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = true
    }
}
