//
//  KeyStroker.swift
//  fflow
//
//  Created by user on 2016/10/02.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


class Keystroke {


    // MARK: Private static property

    static private var error: NSDictionary? = [:]


    // MARK: Private static method
    // MARK: Static property
    // MARK: Static method

    
    // MARK: Private instance property

    fileprivate let key: Key
    fileprivate let shift: Bool
    fileprivate let control: Bool
    fileprivate let option: Bool
    fileprivate let command: Bool

    fileprivate var modifiers: [Key] {

        var modifiers: [Key] = []
        if self.shift { modifiers.append(Key.Shift) }
        if self.control { modifiers.append(Key.Control) }
        if self.option { modifiers.append(Key.Option) }
        if self.command { modifiers.append(Key.Command) }

        return modifiers
    }

    private var modifierSymbols: [String] {

        return self.modifiers.map({ $0.symbol })
    }

    private var symbols: [String] {

        return self.modifierSymbols + [self.key.symbol]
    }


    // MARK: Instance property
    
    var string: String {

        return self.symbols.joined()
    }


    // MARK: Designated init
    
    init?(keyCode: CGKeyCode, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        
        guard let key = Key(fromCode: keyCode) else { return nil }
        self.key = key
        self.shift = shift
        self.control = control
        self.option = option
        self.command = command
    }
    
    init?(keySymbol: String, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        
        guard let key = Key(fromSymbol: keySymbol) else { return nil }
        self.key = key
        self.shift = shift
        self.control = control
        self.option = option
        self.command = command
    }

    init?(keyName: String, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        
        guard let key = Key(fromName: keyName) else { return nil }
        self.key = key
        self.shift = shift
        self.control = control
        self.option = option
        self.command = command
   }
    
    init?(fromString immutableKeystrokeString: String) {

        var keystrokeString = immutableKeystrokeString

        self.shift = keystrokeString.firstIs(it: Key.Shift.symbol)
        if self.shift { keystrokeString.characters.removeFirst() }
        
        self.control = keystrokeString.firstIs(it: Key.Control.symbol)
        if self.control { keystrokeString.characters.removeFirst() }
        
        self.option = keystrokeString.firstIs(it: Key.Option.symbol)
        if self.option { keystrokeString.characters.removeFirst() }
        
        self.command = keystrokeString.firstIs(it: Key.Command.symbol)
        if self.command { keystrokeString.characters.removeFirst() }

        guard let key = Key(fromSymbol: keystrokeString) else { return nil }
        self.key = key
    }

    
    // MARK: Convenience init
    // MARK: Private instance method

    
    // MARK: Instance method

    func dispatchTo(appName: String) {
        
        let modifiersString = self.modifiers.map({$0.name.lowercased() + " down"})
                                            .joined(separator: ",")
        let source = "tell application \"System Events\"\n"
          + "tell process \"\(appName)\"\n"
          + "key code \(key.code) using {\(modifiersString)}\n"
          + "end tell\n"
          + "end tell\n"

        NSAppleScript(source: source)?.executeAndReturnError(&(Keystroke.error))
    }
}





extension Keystroke {

    private var eventSource: CGEventSource? { return CGEventSource(stateID: .hidSystemState) }
    private var hidEventTapLocation: CGEventTapLocation { return .cghidEventTap }

    private var flags: CGEventFlags {

        return [
            self.control ? .maskControl : .maskNonCoalesced,
            self.option ? .maskAlternate : .maskNonCoalesced,
            self.shift ? .maskShift : .maskNonCoalesced,
            self.command ? .maskCommand : .maskNonCoalesced,
        ]
    }

    private func down(keycode: CGKeyCode) -> CGEvent? {

        return CGEvent(keyboardEventSource: self.eventSource, virtualKey: keycode, keyDown: true)
    }

    private func up(keycode: CGKeyCode) -> CGEvent? {

        return CGEvent(keyboardEventSource: self.eventSource, virtualKey: keycode, keyDown: false)
    }

    func dispatchToFrontmostApp() {

        guard let keyDown = self.down(keycode: self.key.code) else { return }
        guard let keyUp = self.up(keycode: self.key.code) else { return }

        keyDown.flags = self.flags

        self.modifiers.forEach({ self.down(keycode: $0.code)?.post(tap: self.hidEventTapLocation) })
        keyDown.post(tap: self.hidEventTapLocation)

        keyUp.post(tap: self.hidEventTapLocation)
        self.modifiers.forEach({ self.up(keycode: $0.code)?.post(tap: self.hidEventTapLocation) })
    }
}
