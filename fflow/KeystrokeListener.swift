//
//  KeystrokeListener.swift
//  fflow
//
//  Created by user on 2017/01/05.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

class KeystrokeListener: NSTextField {

    static private var eventMonitor: Any?

    static private var defaultFont: NSFont { return NSFont.systemFont(ofSize: 13) }

    private func setAppeance(asListening which: Bool) {

        switch which {
        case true:
            self.isEditable = true
            self.isBordered = true
            self.backgroundColor = .white
        default:
            self.isEditable = false
            self.isBordered = false
            self.backgroundColor = .clear
        }
    }

    func listen() {

        self.setAppeance(asListening: true)
        self.setMonitor(asListening: true)
        self.becomeFirstResponder()
    }

    private func blur() {

        self.isEnabled = false
        self.isEnabled = true
    }

    var afterUnlisten: ((Keystroke?) -> Void)?

    func unlisten() {

        self.setAppeance(asListening: false)
        self.setMonitor(asListening: false)
        self.blur()

        self.afterUnlisten?(self.keystroke)
    }

    private func afterListen(event: NSEvent) -> NSEvent? {

        guard let key = Key(code: event.keyCode) else { return nil }

        self.keystroke = Keystroke(key: key, modifierFlags: event.modifierFlags.cgEventFlags)
        self.stringValue = keystroke?.string ?? ""

        self.unlisten()

        return nil
    }

    private func setMonitor(asListening which: Bool) {

        switch which {
        case true:
            guard KeystrokeListener.eventMonitor == nil else { return }
            KeystrokeListener.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown,
                                                                              handler: self.afterListen)
        default:
            guard let eventMonitor = KeystrokeListener.eventMonitor else { return }
            NSEvent.removeMonitor(eventMonitor)
            KeystrokeListener.eventMonitor = nil
        }
    }

    var keystroke: Keystroke?

    override init(frame frameRect: NSRect) {

        super.init(frame: frameRect)

        self.setAppeance(asListening: false)
        self.font = KeystrokeListener.defaultFont
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    deinit {

        self.setMonitor(asListening: false)
    }
}

extension KeystrokeListener {

    func set(keystroke: Keystroke) {

        self.keystroke = keystroke
        self.stringValue = keystroke.string
    }

    func set(keystrokeString: String) {

        guard let keystroke = Keystroke(string: keystrokeString) else { return }

        self.set(keystroke: keystroke)
    }
}
