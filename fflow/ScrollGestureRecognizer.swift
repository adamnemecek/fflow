//
//  GesturePanel.swift
//  fflow
//
//  Created by user on 2017/01/11.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

class GesturePanel: NSImageView {

    private let gesture = Gesture()
    var recognizedGesture: Gesture?

    private var imageSide: CGFloat { return self.frame.size.shortSide }
    private var imageSize: NSSize { return NSSize(squaringOf: self.imageSide) }
    private var margin: CGFloat { return self.imageSide * 0.25 }

    private var lineWidth: CGFloat { return self.imageSide * 0.045 }
    private var color: NSColor { return NSColor.init(white: 0.2, alpha: 1) }

    private var roundedFramePath: NSBezierPath {

        let rect = NSRect(size: self.imageSize)
        let path =  NSBezierPath(roundedRect: rect, xRadius: 15, yRadius: 15)
        path.lineWidth = 1
        path.setLineDash([3, 3], count: 2, phase: 0)

        return path
    }

    private var templateImage: NSImage {

        let image = NSImage(size: self.imageSize)

        image.lockFocus()
        NSColor.darkGray.setStroke()
        self.roundedFramePath.stroke()
        image.unlockFocus()

        return image
    }

    private func imageFrom(path: NSBezierPath) -> NSImage {

        let imageSize = self.imageSize

        path.scaleBounds(within: imageSize.insetBy(dx: self.margin, dy: self.margin))
        path.setBoundsCenter(of: .init(size: imageSize))

        path.lineWidth = self.lineWidth

        let image = self.templateImage
        image.lockFocus()

        self.color.setStroke()
        path.stroke()
        image.unlockFocus()

        return image
    }

    func updateImage(by gesture: Gesture?) {

        guard let gesture = gesture else {

            self.image = self.templateImage
            return
        }

        self.image = self.imageFrom(path: gesture.naturalPath)
    }

    func resetImage() {

        self.updateImage(by: nil)
    }

    var afterRecognized: ((Gesture) -> Void)?

    override init(frame frameRect: NSRect) {

        super.init(frame: frameRect)

        self.resetImage()

        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel, handler: {(event: NSEvent) -> NSEvent? in

            guard let direction = ValidScroll(deltaX: event.naturalScrollingDeltaX,
                                              deltaY: event.naturalScrollingDeltaY)?.direction else {

                return event
            }

            if let gesture = self.gesture.appendAndReleaseIfCan(direction: direction) {

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
