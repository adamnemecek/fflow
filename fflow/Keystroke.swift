//
//  KeyStroker.swift
//  fflow
//
//  Created by user on 2016/10/02.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class Keystroke {

    fileprivate let key: Key
    fileprivate let control: Bool
    fileprivate let option: Bool
    fileprivate let shift: Bool
    fileprivate let command: Bool

    fileprivate var modifiers: [Key] {

        var modifiers: [Key] = []
        if self.control { modifiers.append(Key.Control) }
        if self.option { modifiers.append(Key.Option) }
        if self.shift { modifiers.append(Key.Shift) }
        if self.command { modifiers.append(Key.Command) }

        return modifiers
    }

    private var modifierSymbols: [String] {

        return self.modifiers.map({ $0.symbol })
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

protocol CanDispatch {

    func dispatchToFrontmostApp()
}

extension CanDispatch where Self: Keystroke {

    static fileprivate var location: CGEventTapLocation { return .cghidEventTap }

    fileprivate var flags: CGEventFlags {

        return [
            self.control ? .maskControl   : .maskNonCoalesced,
            self.option ?  .maskAlternate : .maskNonCoalesced,
            self.shift ?   .maskShift     : .maskNonCoalesced,
            self.command ? .maskCommand   : .maskNonCoalesced
        ]
    }
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

    convenience init?(keyCode: CGKeyCode, modifierFlags: NSEventModifierFlags) {

        self.init(keyCode: keyCode,
                  control: modifierFlags.contains(.control),
                  option: modifierFlags.contains(.option),
                  shift: modifierFlags.contains(.shift),
                  command: modifierFlags.contains(.command))
    }
}
