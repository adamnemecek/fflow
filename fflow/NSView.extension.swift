//
//  NSView.extension.swift
//  fflow
//
//  Created by user on 2016/12/17.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

extension NSView {

    convenience init(size: NSSize) {

        self.init(frame: .init(origin: .zero, size: size))
    }
}

extension NSView {

    func center() {

        guard let origin = self.originOfCenteredRect() else { return }
        self.setFrameOrigin(origin)
    }

    private func originOfCenteredRect() -> NSPoint? {

        guard let superview = self.superview else { return nil }
        
        let parent = superview.frame.size
        let child = self.frame.size

        let x = (parent.width - child.width) / 2
        let y = (parent.height - child.height) / 2
        
        return NSPoint(x: x, y: y)
    }
}
