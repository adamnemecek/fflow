//
//  NSRect.extension.swift
//  fflow
//
//  Created by user on 2016/12/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

extension NSRect {

    var shortSide: CGFloat {

        return self.size.shortSide
    }

    var longSide: CGFloat {

        return self.size.longSide
    }
}

extension NSRect {

    init(size: NSSize) {

       self.init(origin: .zero, size: size)
    }

    init(width: CGFloat, height: CGFloat) {

        self.init(x: 0, y: 0, width: width, height: height)
    }
}

extension NSRect {

    mutating func center(of superrect: NSRect) {

        let x = (superrect.width - self.width) / 2
        let y = (superrect.height - self.height) / 2

        self.origin = .init(x: x, y: y)
    }

    init(center: NSPoint, size: NSSize) {

        let x = center.x - size.width / 2
        let y = center.y - size.height / 2
        let origin = NSPoint(x: x, y: y)

        self.init(origin: origin, size: size)
    }

    var centerPoint: NSPoint {

        return NSPoint(x: self.midX, y: self.midY)
    }
}
