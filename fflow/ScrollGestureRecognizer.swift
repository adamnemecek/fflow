//
//  ScrollGestureRecognizer.swift
//  fflow
//
//  Created by user on 2017/01/11.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

class ScrollGestrueRecognizer: NSImageView {

    private let gesture = Gesture()
    var recognizedGesture: Gesture?

    private var imageSide: CGFloat { return self.frame.size.shortSide }
    private var imageSize: NSSize { return NSSize(squaringOf: self.imageSide) }

    private var margin: CGFloat { return self.imageSide * 0.25 }
    private var lineWidth: CGFloat { return self.imageSide * 0.045 }
    private var color: NSColor { return NSColor.init(white: 0.2, alpha: 1) }

    private func imageFrom(path: NSBezierPath) -> NSImage {

        let imageSize = self.imageSize

        path.scaleBounds(within: imageSize.insetBy(dx: self.margin, dy: self.margin))
        path.setBoundsCenter(of: .init(size: imageSize))

        path.lineWidth = self.lineWidth

        let image = NSImage(size: imageSize)
        image.lockFocus()
        self.color.setStroke()
        path.stroke()
        image.unlockFocus()

        return image
    }

    func updateImage(by gesture: Gesture) {

        self.image = self.imageFrom(path: gesture.naturalPath)
    }

    var afterRecognized: ((Gesture) -> Void)?

    override init(frame frameRect: NSRect) {

        super.init(frame: frameRect)

        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel, handler: {(event: NSEvent) -> NSEvent? in

            let x = event.scrollingDeltaX
            let y = event.scrollingDeltaY

            if let gesture = self.gesture.appendAndReleaseIfCan(x: x, y: y) {

                self.recognizedGesture = gesture

                self.updateImage(by: gesture)

                self.afterRecognized?(gesture)
            }

            return event
        })
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}
