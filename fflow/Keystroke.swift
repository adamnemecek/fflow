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
}

private protocol CanInitWithSymbol {

    init?(string: String)
}

extension CanInitWithSymbol {

    static fileprivate func recognizeFlags(symbols: String) -> CGEventFlags {

        var flags: CGEventFlags = []

        if symbols.contains(Key.Control.symbol) { flags.formUnion(.maskControl) }
        if symbols.contains(Key.Option.symbol) { flags.formUnion(.maskAlternate) }
        if symbols.contains(Key.Shift.symbol) { flags.formUnion(.maskShift) }
        if symbols.contains(Key.Command.symbol) { flags.formUnion(.maskCommand) }

        return flags
    }

    static fileprivate func recognizeKey(symbols: String) -> Key? {

        let keySymbol = symbols.removingOccurrence(of: Key.Control.symbol)
                               .removingOccurrence(of: Key.Option.symbol)
                               .removingOccurrence(of: Key.Shift.symbol)
                               .removingOccurrence(of: Key.Command.symbol)
        return Key(symbol: keySymbol)
    }
}

extension Keystroke: CanInitWithSymbol {

    init?(string: String) {

        guard let key = Keystroke.recognizeKey(symbols: string) else { return nil }

        self.modifierFlags = Keystroke.recognizeFlags(symbols: string)
        self.key = key
    }
}

private protocol CanDispatch {

    func dispatchToFrontmostApp()
}

extension Keystroke: CanDispatch {

    func dispatchToFrontmostApp() {

        self.key.down(using: self.modifierFlags)
        self.key.up(using: self.modifierFlags)
    }
}

private protocol CanSerialize {

    func serialized() -> [String: UInt16]
    init?(serialized: [String: Any]?)
}

extension Keystroke: CanSerialize {

    func serialized() -> [String: UInt16] {

        return [
            "keyCode": self.key.code,
            "control": self.modifierFlags.contains(.maskControl)   ? 1 : 0,
             "option": self.modifierFlags.contains(.maskAlternate) ? 1 : 0,
              "shift": self.modifierFlags.contains(.maskShift)     ? 1 : 0,
            "command": self.modifierFlags.contains(.maskCommand)   ? 1 : 0
        ]
    }

    init?(serialized: [String: Any]?) {

        guard let dictionary = serialized as? [String: UInt16] else { return nil }

        guard let keyCode = dictionary["keyCode"] else { return nil }
        guard let key = Key(code: keyCode) else { return nil }

        guard let control = dictionary["control"] else { return nil }
        guard let option = dictionary["option"] else { return nil }
        guard let shift = dictionary["shift"] else { return nil }
        guard let command = dictionary["command"] else { return nil }

        self.key = key
        self.modifierFlags = [
            control == 1 ? .maskControl   : .maskNonCoalesced,
            option  == 1 ? .maskAlternate : .maskNonCoalesced,
            shift   == 1 ? .maskShift     : .maskNonCoalesced,
            command == 1 ? .maskCommand   : .maskNonCoalesced
        ]
    }
}
