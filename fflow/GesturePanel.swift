//
//  GesturePanel.swift
//  fflow
//
//  Created by user on 2017/01/11.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

private protocol CanRecognize {

    var recognizedGesture: Gesture? { get }
    var afterRecognized: ((Gesture) -> Void)? { get set }
}

private protocol CanShowPath {}

extension CanShowPath where Self: NSImageView {

    private var imageSide: CGFloat { return self.frame.size.shortSide }
    private var imageSize: NSSize { return NSSize(squaringOf: self.imageSide) }
    private var imageRect: NSRect { return NSRect(size: self.imageSize) }

    private var margin: CGFloat { return self.imageSide * 0.25 }

    private var lineWidth: CGFloat { return self.imageSide * 0.045 }
    private var color: NSColor { return NSColor.init(white: 0.2, alpha: 1) }

    private var roundedFramePath: NSBezierPath {

        let path =  NSBezierPath(roundedRect: self.imageRect, xRadius: 15, yRadius: 15)
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

    fileprivate func updateImage(by gesture: Gesture?) {

        guard let gesture = gesture else {

            self.image = self.templateImage
            return
        }

        self.image = self.imageFrom(path: gesture.naturalPath)
    }

    fileprivate func resetImage() {

        self.updateImage(by: nil)
    }
}

class GesturePanel: NSImageView, CanRecognize, CanShowPath {

    private let recognizingGesture = Gesture()

    fileprivate var onRecognized: ((Gesture) -> Void)?

    private func onScrollWheel(event: NSEvent) -> NSEvent? {

        guard let direction = ValidScroll(deltaX: event.naturalScrollingDeltaX,
                                          deltaY: event.naturalScrollingDeltaY)?.direction else {

            return event
        }

        if let gesture = self.recognizingGesture.appendAndReleaseIfCan(direction: direction) {

            self.recognizedGesture = gesture

            self.onRecognized?(gesture)

            self.afterRecognized?(gesture)
        }

        return event
    }

    var recognizedGesture: Gesture?
    var afterRecognized: ((Gesture) -> Void)?

    override init(frame frameRect: NSRect) {

        super.init(frame: frameRect)

        self.resetImage()

        self.onRecognized = {(gesture) in self.updateImage(by: gesture) }

        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel, handler: self.onScrollWheel)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}
