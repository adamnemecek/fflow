//
//  StatusItemImage.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class StatusItem {

    // MARK: Private static property

    static private func f(size: NSSize) -> NSBezierPath {

        let fHeight = size.height * 0.75
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

    static private func icon(size: NSSize, fPath: NSBezierPath) -> NSImage {

        let rect = NSRect(origin: .zero, size: size)
        let oval = NSBezierPath(ovalIn: rect)

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

    // MARK: Private static method
    // MARK: Static property
    // MARK: Static method
    // MARK: Private instance property

    private let iconSize = NSSize(width: 18, height: 18)
    private let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

    // MARK: Instance property

    // MARK: Designated init

    init(menuItems: [NSMenuItem]) {

        let menu = NSMenu()
        menuItems.forEach({ menu.addItem($0) })

        self.statusItem.menu = menu
        self.statusItem.highlightMode = true
        self.statusItem.image = StatusItem.icon(size: self.iconSize,
                                                fPath: StatusItem.f(size: self.iconSize))
    }

    // MARK: Convenience init
    // MARK: Private instance method
    // MARK: Instance method

    private func menuItem(title: String, selector: Selector?) -> NSMenuItem {

        let menuItem = NSMenuItem()
        menuItem.title = title
        menuItem.action = selector
        return menuItem
    }

    static private func quit() {

        NSApplication.shared().terminate(self)
    }
}
