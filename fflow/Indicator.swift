//
//  Indecator.swift
//  fflow
//
//  Created by user on 2016/10/13.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class Indicator: NSObject {

    static fileprivate let side: CGFloat = 130

    static private var center: NSPoint {

        guard let frame = NSScreen.mousePointed()?.frame else { return .zero }

        return frame.centerPoint
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

        panel.contentView = Indicator.contentView

        panel.backgroundColor = .clear
        panel.hasShadow = false

        panel.isFloatingPanel = true // to be visible even if target app isn't fullscreen

        return panel
    }

    fileprivate let panel: NSPanel

    override init() {

        self.panel = Indicator.panel

        super.init()
    }

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

    fileprivate func showPanel() {

        self.panel.setFrame(Indicator.frame, display: false)

        self.panel.orderFront(nil)
    }

    func show(text: String) {

        guard let contentView = self.panel.contentView else { return }

        let textView = self.textView
        textView.string = text

        contentView.addSubview(textView)

        self.showPanel()
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

        self.showPanel()
    }
}

protocol CanFadeout: CAAnimationDelegate {

    func showAndFadeout(text: String) -> Void
    func showAndFadeout(gesture: Gesture) -> Void
}

extension CanFadeout where Self: Indicator {

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
}

extension Indicator: CanFadeout {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        self.close()
    }
}
