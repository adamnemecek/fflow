//
//  KeyStroker.swift
//  fflow
//
//  Created by user on 2016/10/02.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


class Keystroke {
    
    var keyCode: Int? = nil
    var modifierKeys: [String] = []
    var error: NSDictionary? = [:]
    
    init(keyCode: Int, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        
        self.keyCode = keyCode
        if control { modifierKeys.append("control") }
        if option { modifierKeys.append("option") }
        if shift { modifierKeys.append("shift") }
        if command { modifierKeys.append("command") }
    }
    
    init?(fromString: String) {
        
        var parts: [String] = fromString.characters.split(separator: "-").map({String($0)})
        
        guard let key = parts.popLast() else { return nil }
        
        for part in parts {
            
            switch (part) {
            case "shift": modifierKeys.append("shift")
            case "control": modifierKeys.append("control")
            case "option": modifierKeys.append("option")
            case "command": modifierKeys.append("command")
            default: break
            }
        }
        
    }
    
    func dispatchTo(appName: String) {
        
        let modifierKeysSentence = modifierKeys.map({$0 + " down"}).joined(separator: ",")
        let source = "tell application \"System Events\"\n"
          + "tell process \"\(appName)\"\n"
          + "key code \(keyCode) using {\(modifierKeysSentence)}\n"
          + "end tell\n"
          + "end tell\n"
        NSAppleScript(source: source)?.executeAndReturnError(&error)
    }
    
    func toString() -> String {
        return "\(modifierKeys.joined(separator: "-"))-\(keyCode)"
    }
}
