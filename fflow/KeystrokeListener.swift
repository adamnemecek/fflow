//
//  KeystrokeListener.swift
//  fflow
//
//  Created by user on 2017/01/05.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

class KeystrokeListener: NSTextField {

    var keystroke: Keystroke?

    private var eventMonitor: Any?

    private func keyDownHandler(event: NSEvent) -> NSEvent? {

        self.keystroke = Keystroke(keyCode: event.keyCode, modifierFlags: event.modifierFlags)

        guard let stringValue = keystroke?.string else { return nil }

        self.stringValue = stringValue

        self.unlisten()

        return nil
    }

    private func blur() {

        self.isEnabled = false
        self.isEnabled = true
    }

    func listen() {

        self.isEditable = true

        self.isBordered = true
        self.backgroundColor = .white

        self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: self.keyDownHandler)

        self.becomeFirstResponder()
    }

    private var afterUnlisten: (() -> Void)?

    func afterUnlisten(handler: (() -> Void)?) {

        self.afterUnlisten = handler
    }

    private func unlisten() {

        self.isEditable = false

        self.isBordered = false
        self.backgroundColor = .clear

        guard let eventMonitor = self.eventMonitor else { return }

        NSEvent.removeMonitor(eventMonitor)

        self.blur()

        self.afterUnlisten?()
    }

    override init(frame frameRect: NSRect) {

        super.init(frame: frameRect)

        self.unlisten()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}

extension KeystrokeListener {

    func set(keystroke: Keystroke) {

        self.keystroke = keystroke
        self.stringValue = keystroke.string
    }

    func set(keystrokeString: String) {

        guard let keystroke = Keystroke(fromString: keystrokeString) else { return }

        self.set(keystroke: keystroke)
    }
}
