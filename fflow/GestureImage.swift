//
//  GestureImage.swift
//  fflow
//
//  Created by user on 2017/07/09.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

class GestureImage {

    let gesture: Gesture

    init(gesture: Gesture) {

        self.gesture = gesture
    }
}

private protocol HasGesturePath {

    var path: NSBezierPath { get }
}

extension HasGesturePath  where Self: GestureImage {

    static private var initialPathLength: CGFloat { return 100 }

    static private func startAngle(prev: Direction, current: Direction) -> CGFloat {

        if prev.isVertical { return current == .Left ? 0 : 180 }
        if current == .Up { return 270 }

        return 90
    }

    static private func endAngle(prev: Direction, current: Direction) -> CGFloat {

        if prev == .Up { return 90 }
        if prev == .Down { return 270 }
        if prev == .Left { return 180 }
        return 0
    }

    static private func isClockwise(prev: Direction, current: Direction) -> Bool {

        switch (prev, current) {
        case (.Right, .Up): fallthrough
        case (.Up, .Left): fallthrough
        case (.Left, .Down): fallthrough
        case (.Down, .Right): fallthrough
        case (.Left, .Right): fallthrough
        case (.Down, .Up): return false
        default:
            return true
        }
    }

    static private var rivetSize: NSSize { return NSSize(squaringOf: 9) }

    static private func rivet(at center: NSPoint) -> NSBezierPath {

        let rect = NSRect(center: center, size: self.rivetSize)
        let rivet = NSBezierPath(ovalIn: rect)
        rivet.move(to: center)

        return rivet
    }

    static private var radius: CGFloat { return self.initialPathLength * 0.3 }

    static private func joint(at startPoint: NSPoint, prev: Direction, current: Direction) -> NSBezierPath {

        let arc = NSBezierPath(initialPoint: startPoint)

        guard prev != .No else { return arc }

        let startAngle = self.startAngle(prev: prev, current: current)
        let endAngle = Self.endAngle(prev: prev, current: current)

        Self.isClockwise(prev: prev, current: current)
            ? arc.clockwise(radius: self.radius, startAngle: startAngle, endAngle: endAngle)
            : arc.counterClockwise(radius: self.radius, startAngle: startAngle, endAngle: endAngle)

        return arc
    }

    var path: NSBezierPath {

        let path = NSBezierPath(initialPoint: .zero)
        path.lineCapStyle = .roundLineCapStyle

        var length = Self.initialPathLength
        var prev: Direction = .No

        for current in self.gesture.directions {

            let joint = Self.joint(at: path.currentPoint, prev: prev, current: current)
            path.append(joint)

            let rivet = Self.rivet(at: path.currentPoint)
            path.append(rivet)

            path.relativeLine(to: (length * current.unitVector).endPoint)

            prev = current
            length *= 0.9
        }

        return path
    }
}


private protocol CanGivePathImage: HasGesturePath {

    var image: NSImage { get }
}

extension CanGivePathImage where Self: GestureImage {

    static private var imageSide: CGFloat { return 100 }
    static private var imageSize: NSSize { return NSSize(squaringOf: self.imageSide) }
    static private var templateImage: NSImage { return NSImage(size: self.imageSize) }

    static private var lineWidth: CGFloat { return self.imageSide * 0.045 }
    static private var margin: CGFloat { return self.imageSide * 0.25 }
    static private var pathSize: NSSize { return self.imageSize.insetBy(bothDxDy: self.margin) }
    static private var imageRect: NSRect { return NSRect(size: self.imageSize) }

    static private func suitabled(path: NSBezierPath) -> NSBezierPath {

        path.lineWidth = self.lineWidth

        path.scaleBounds(within: self.pathSize)
        path.setBoundsCenter(of: self.imageRect)

        return path
    }

    static private var color: NSColor { return NSColor(white: 0.2, alpha: 1) }

    var image: NSImage {

        let image = Self.templateImage

        image.lockFocus()
        Self.color.setStroke()
        Self.suitabled(path: path).stroke()
        image.unlockFocus()

        return image
    }
}

extension GestureImage: CanGivePathImage {}
