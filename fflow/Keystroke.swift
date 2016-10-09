//
//  KeyStroker.swift
//  fflow
//
//  Created by user on 2016/10/02.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


class Keystroke {
    
    var key: Key
    var modifiers: [Key] = []
    var error: NSDictionary? = [:]
    
    init?(keyCode: UInt8, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        
        guard let key = Key(fromCode: keyCode) else { return nil }
        self.key = key
        self.modifiers = detectModifiers(shift: shift, control: control, option: option, command: command)
    }
    
    init?(keySymbol: String, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        
        guard let key = Key(fromSymbol: keySymbol) else { return nil }
        self.key = key
        self.modifiers = detectModifiers(shift: shift, control: control, option: option, command: command)
    }
    
    init?(keyName: String, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        
        guard let key = Key(fromName: keyName) else { return nil }
        self.key = key
        self.modifiers = detectModifiers(shift: shift, control: control, option: option, command: command)
    }
    
    init?(fromString: String) {
        
        let parts: [String] = fromString.characters.split(separator: "-").map({String($0)})
        
        var key: Key? = nil
        for part in parts {
            
            switch (part) {
            case "shift": modifiers.append(Key.shift)
            case "control": modifiers.append(Key.control)
            case "option": modifiers.append(Key.option)
            case "command": modifiers.append(Key.command)
            default: key = Key(fromSymbol: part)
            }
        }
        
        guard key != nil else { return nil }
        self.key = key!
    }
    
    private func detectModifiers(shift: Bool, control: Bool, option: Bool, command: Bool) -> [Key] {
        var modifiers: [Key] = []
        if control { modifiers.append(Key.control) }
        if option { modifiers.append(Key.option) }
        if shift { modifiers.append(Key.shift) }
        if command { modifiers.append(Key.command) }
        return modifiers
    }
    
    func dispatchTo(appName: String) {
        
        let modifierStrings = modifiers.map({$0.name.lowercased() + " down"})
        let source = "tell application \"System Events\"\n"
          + "tell process \"\(appName)\"\n"
          + "key code \(key.code) using {\(modifierStrings.joined(separator: ","))}\n"
          + "end tell\n"
          + "end tell\n"
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }
    
    func toString() -> String {
        let modifierStrings = modifiers.map({$0.name.lowercased()})
        return "\(modifierStrings.joined(separator: "-"))-\(key.symbol)"
    }
}
