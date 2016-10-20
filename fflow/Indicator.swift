//
//  Indecator.swift
//  fflow
//
//  Created by user on 2016/10/13.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa


class Indicator: NSObject, CAAnimationDelegate {
    
    private var panel: NSPanel! = nil
    var textView: NSTextView = NSTextView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
    let opacityAnimation = CABasicAnimation(keyPath: "opacity")

    override init() {
        
        super.init()
        
        textView.backgroundColor = .clear
        textView.string = "asdfg"
        textView.font = NSFont(name: "Helvetica", size: 30)
        textView.textColor = NSColor(calibratedWhite: 0.2, alpha: 1.0)
        textView.alignCenter(nil)
        textView.frame = textView.layoutManager!.usedRect(for: textView.textContainer!)
        
        // Setting for animation of opacity
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.1
        opacityAnimation.delegate = self    // For animationDidStop method
        opacityAnimation.isRemovedOnCompletion = false
//        opacityAnimation.fillMode = kCAFillModeForwards
    }

    func show(arrowString: String) {
        
        textView.string = arrowString
        
        panel = NSPanel(contentRect: NSMakeRect(0, 0, 100, 100),
                        styleMask: [.nonactivatingPanel],
                        backing: NSBackingStoreType.buffered,
                        defer: false)

        panel.backgroundColor = .clear
        panel.contentView?.wantsLayer = true
        panel.contentView?.layer?.cornerRadius = 20.0
        panel.contentView?.layer?.backgroundColor = NSColor(white: 0.8, alpha: 1).cgColor
        
        panel.contentView?.addSubview(textView)
        panel.hasShadow = false
        panel.center()
        panel.orderFront(nil)
        
        alignCenter(of: textView)
        alignCenterOfScreen(panel: panel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.panel.contentView?.layer?.add(self.opacityAnimation, forKey: "opacity")
        })
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.panel?.close()
        self.textView.string = ""
    }
    
    private func alignCenterOfScreen(panel: NSPanel) {
        guard let screenSize = NSScreen.main()?.frame.size else { return }
        panel.setFrameOrigin(originOfCenteredRect(of: panel.frame.size, in: screenSize))
        let dy = -1 * screenSize.height / 6
        panel.setFrame(panel.frame.offsetBy(dx: 0, dy: dy), display: true)
    }
    
    private func alignCenter(of view: NSView) {
        guard let superviewSize = view.superview?.frame.size else { return }
        let viewSize = view.frame.size
        view.setFrameOrigin(originOfCenteredRect(of: viewSize, in: superviewSize))
    }
    
    private func originOfCenteredRect(of childSize: NSSize, in parentSize: NSSize) -> NSPoint {
        let x = (parentSize.width - childSize.width) / 2
        let y = (parentSize.height - childSize.height) / 2
        return NSMakePoint(x, y)
    }
    
}
