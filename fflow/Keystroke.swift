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
