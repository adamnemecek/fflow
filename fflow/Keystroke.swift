//
//  KeyStroker.swift
//  fflow
//
//  Created by user on 2016/10/02.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

struct Keystroke {

    var key: Key
    var modifierFlags: CGEventFlags = []
}

private protocol CanGiveString {

    var string: String { get }
}

extension Keystroke: CanGiveString {

    private var modifierSymbols: [String] {

        return self.modifierFlags.keys().map({ $0.symbol })
    }

    private var symbols: [String] {

        return self.modifierSymbols + [self.key.symbol]
    }

    var string: String {

        return self.symbols.joined()
    }

    init?(keyCode: CGKeyCode, control: Bool = false, option: Bool = false, shift: Bool = false, command: Bool = false) {

        guard let key = Key(code: keyCode) else { return nil }
        self.key = key
        self.control = control
        self.option = option
        self.shift = shift
        self.command = command
    }

    init?(string immutableKeystrokeString: String) {

        var keystrokeString = immutableKeystrokeString

        self.control = keystrokeString.firstIs(it: Key.Control.symbol)
        if self.control { keystrokeString.characters.removeFirst() }

        self.option = keystrokeString.firstIs(it: Key.Option.symbol)
        if self.option { keystrokeString.characters.removeFirst() }

        self.shift = keystrokeString.firstIs(it: Key.Shift.symbol)
        if self.shift { keystrokeString.characters.removeFirst() }

        self.command = keystrokeString.firstIs(it: Key.Command.symbol)
        if self.command { keystrokeString.characters.removeFirst() }

        guard let key = Key(symbol: keystrokeString) else { return nil }
        self.key = key
    }
}

private protocol CanDispatch {

    func dispatchToFrontmostApp()
}

extension CanDispatch {

    static fileprivate var location: CGEventTapLocation { return .cghidEventTap }
}

extension Keystroke: CanDispatch {

    func dispatchToFrontmostApp() {

        guard let downEvent = self.key.downEvent else { return }
        guard let upEvent   = self.key.upEvent   else { return }

        self.modifiers.forEach({ $0.downEvent?.post(tap: Keystroke.location) })
        downEvent.flags = self.flags
        downEvent.post(tap: Keystroke.location)
        upEvent.post(tap: Keystroke.location)
        self.modifiers.forEach({ $0.upEvent?.post(tap: Keystroke.location) })
    }
}

extension Keystroke {

    init?(keyCode: CGKeyCode, modifierFlags: NSEventModifierFlags) {

        self.init(keyCode: keyCode,
                  control: modifierFlags.contains(.control),
                  option: modifierFlags.contains(.option),
                  shift: modifierFlags.contains(.shift),
                  command: modifierFlags.contains(.command))
    }
}
