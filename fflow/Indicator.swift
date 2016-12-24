//
//  Indecator.swift
//  fflow
//
//  Created by user on 2016/10/13.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa


class Indicator: NSObject {

    // MARK: Private static property

    static fileprivate let side: CGFloat = 130

    static private var center: NSPoint {

        guard let screenSize = NSScreen.main()?.frame.size else { return .zero }

        return .init(x: screenSize.width / 2,
                     y: screenSize.height / 3)
    }

    static fileprivate var size: NSSize {

        return .init(squaringOf: Indicator.side)
    }

    static private var frame: NSRect {

        return .init(center: Indicator.center, size: Indicator.size)
    }

    static fileprivate var contentView: NSView {

        let view = NSView(size: Indicator.size)
        view.wantsLayer = true
        view.layer?.cornerRadius = 20
        view.layer?.backgroundColor = NSColor(white: 0.8, alpha: 1).cgColor

        return view
    }

    static fileprivate var panel: NSPanel {

        let panel = NSPanel(contentRect: Indicator.frame,
                            styleMask: [.nonactivatingPanel],
                            backing: NSBackingStoreType.buffered,
                            defer: false)

        panel.contentView = self.contentView

        panel.backgroundColor = .clear
        panel.hasShadow = false

        return panel
    }


    // MARK: Private static method
    // MARK: Static property
    // MARK: Static method


    // MARK: Private instance property

    fileprivate let panel: NSPanel

    private var textView: NSTextView {

        let fontSize: CGFloat = 40

        let textView = NSTextView()
        textView.backgroundColor = .clear
        textView.font = NSFont(name: "Helvetica", size: fontSize)
        textView.textColor = NSColor(calibratedWhite: 0.2, alpha: 1.0)
        textView.alignCenter(nil)

        let textViewSize = NSSize(width: Indicator.side, height: fontSize)
        textView.setFrameSize(textViewSize)
        textView.frame.center(of: Indicator.frame)

        return textView
    }


    // MARK: Instance property

    
    // MARK: Designated init

    override init() {

        self.panel = Indicator.panel
        super.init()
    }


    // MARK: Convenience init


    // MARK: Private instance method


    // MARK: Instance method

    func show(text: String) {

        guard let contentView = self.panel.contentView else { return }

        let textView = self.textView
        textView.string = text
        
        contentView.addSubview(textView)

        self.panel.orderFront(nil)
    }

    func close() {

        self.panel.close()
        self.panel.contentView = Indicator.contentView
    }
}


extension Indicator {

    private var imageView: NSImageView { return .init(size: Indicator.size) }
    private var image: NSImage { return NSImage(size: self.imageView.frame.size) }

    private var margin: CGFloat { return Indicator.side * 0.25 }
    private var lineWidth: CGFloat { return Indicator.side * 0.045 }
    private var color: NSColor { return NSColor.init(white: 0.2, alpha: 1) }

    private func imageFrom(path: NSBezierPath) -> NSImage {

        path.lineWidth = self.lineWidth

        let size = NSSize(squaringOf: self.image.size.width - 2 * self.margin)
        path.scaleBounds(within: size)

        path.setBoundsCenter(of: .init(size: self.image.size))

        let image = self.image
        image.lockFocus()
        self.color.setStroke()
        path.stroke()
        image.unlockFocus()

        return image
    }

    func show(gesture: Gesture) {

        guard let contentView = self.panel.contentView else { return }

        let path = gesture.path
        let image = self.imageFrom(path: path)

        let imageView = self.imageView
        imageView.image = image
        contentView.addSubview(imageView)

        self.panel.orderFront(nil)
    }
}


extension Indicator: CAAnimationDelegate {

    private var opacityAnimation: CABasicAnimation {

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.duration = 0.1
        animation.isRemovedOnCompletion = false
//        animation.fillMode = kCAFillModeForwards
        animation.delegate = self

        return animation
    }

    private func fadeout() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {

            guard let layer = self.panel.contentView?.layer else {

                self.close()
                return
            }

            layer.add(self.opacityAnimation, forKey: "opacity")
        })
    }
    
    func showAndFadeout(text: String) {

        self.show(text: text)
        self.fadeout()
    }
    
    func showAndFadeout(gesture: Gesture) {

        self.show(gesture: gesture)
        self.fadeout()
    }


    // MARK: CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        self.close()
    }
}
