//
//  Key.swift
//  fflow
//
//  Created by user on 2016/10/09.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

class Key {
    
    struct KeyStruct {
        let name: String
        let symbol: String
        let code: UInt8
    }
    
    static let keys = [
        KeyStruct(name: "Zero", symbol: "0", code: 29),
        KeyStruct(name: "One", symbol: "1", code: 18),
        KeyStruct(name: "Two", symbol: "2", code: 19),
        KeyStruct(name: "Three", symbol: "3", code: 20),
        KeyStruct(name: "Four", symbol: "4", code: 21),
        KeyStruct(name: "Five", symbol: "5", code: 23),
        KeyStruct(name: "Six", symbol: "6", code: 22),
        KeyStruct(name: "Seven", symbol: "7", code: 26),
        KeyStruct(name: "Eight", symbol: "8", code: 28),
        KeyStruct(name: "Nine", symbol: "9", code: 25),
        KeyStruct(name: "A", symbol: "A", code: 0),
        KeyStruct(name: "B", symbol: "B", code: 11),
        KeyStruct(name: "C", symbol: "C", code: 8),
        KeyStruct(name: "D", symbol: "D", code: 2),
        KeyStruct(name: "E", symbol: "E", code: 14),
        KeyStruct(name: "F", symbol: "F", code: 3),
        KeyStruct(name: "G", symbol: "G", code: 5),
        KeyStruct(name: "H", symbol: "H", code: 4),
        KeyStruct(name: "I", symbol: "I", code: 34),
        KeyStruct(name: "J", symbol: "J", code: 38),
        KeyStruct(name: "K", symbol: "K", code: 40),
        KeyStruct(name: "L", symbol: "L", code: 37),
        KeyStruct(name: "M", symbol: "M", code: 46),
        KeyStruct(name: "N", symbol: "N", code: 45),
        KeyStruct(name: "O", symbol: "O", code: 31),
        KeyStruct(name: "P", symbol: "P", code: 35),
        KeyStruct(name: "Q", symbol: "Q", code: 12),
        KeyStruct(name: "R", symbol: "R", code: 15),
        KeyStruct(name: "S", symbol: "S", code: 1),
        KeyStruct(name: "T", symbol: "T", code: 17),
        KeyStruct(name: "U", symbol: "U", code: 32),
        KeyStruct(name: "V", symbol: "V", code: 9),
        KeyStruct(name: "W", symbol: "W", code: 13),
        KeyStruct(name: "X", symbol: "X", code: 7),
        KeyStruct(name: "Y", symbol: "Y", code: 16),
        KeyStruct(name: "Z", symbol: "Z", code: 6),
        KeyStruct(name: "SectionSign", symbol: "§", code: 10),
        KeyStruct(name: "Grave", symbol: "`", code: 50),
        KeyStruct(name: "Minus", symbol: "-", code: 27),
        KeyStruct(name: "Equal", symbol: "#ERROR!", code: 24),
        KeyStruct(name: "LeftBracket", symbol: "[", code: 33),
        KeyStruct(name: "RightBracket", symbol: "]", code: 30),
        KeyStruct(name: "Semicolon", symbol: ";", code: 41),
        KeyStruct(name: "Quote", symbol: "", code: 39),
        KeyStruct(name: "Comma", symbol: ",", code: 43),
        KeyStruct(name: "Period", symbol: ".", code: 47),
        KeyStruct(name: "Slash", symbol: "/", code: 44),
        KeyStruct(name: "Backslash", symbol: "\\", code: 42),
        KeyStruct(name: "Keypad0", symbol: "0", code: 82),
        KeyStruct(name: "Keypad1", symbol: "1", code: 83),
        KeyStruct(name: "Keypad2", symbol: "2", code: 84),
        KeyStruct(name: "Keypad3", symbol: "3", code: 85),
        KeyStruct(name: "Keypad4", symbol: "4", code: 86),
        KeyStruct(name: "Keypad5", symbol: "5", code: 87),
        KeyStruct(name: "Keypad6", symbol: "6", code: 88),
        KeyStruct(name: "Keypad7", symbol: "7", code: 89),
        KeyStruct(name: "Keypad8", symbol: "8", code: 91),
        KeyStruct(name: "Keypad9", symbol: "9", code: 92),
        KeyStruct(name: "KeypadDecimal", symbol: ".", code: 65),
        KeyStruct(name: "KeypadMultiply", symbol: "*", code: 67),
        KeyStruct(name: "KeypadPlus", symbol: "#ERROR!", code: 69),
        KeyStruct(name: "KeypadDivide", symbol: "/", code: 75),
        KeyStruct(name: "KeypadMinus", symbol: "-", code: 78),
        KeyStruct(name: "KeypadEquals", symbol: "#ERROR!", code: 81),
        KeyStruct(name: "KeypadClear", symbol: "⌧", code: 71),
        KeyStruct(name: "KeypadEnter", symbol: "⌤", code: 76),
        KeyStruct(name: "Space", symbol: "␣", code: 49),
        KeyStruct(name: "Return", symbol: "⏎", code: 36),
        KeyStruct(name: "Tab", symbol: "⇥", code: 48),
        KeyStruct(name: "Delete", symbol: "⌫", code: 51),
        KeyStruct(name: "ForwardDelete", symbol: "⌦", code: 117),
        KeyStruct(name: "Linefeed ?", symbol: "␊", code: 52),
        KeyStruct(name: "Escape", symbol: "⎋", code: 53),
        KeyStruct(name: "Command", symbol: "⌘", code: 55),
        KeyStruct(name: "Shift", symbol: "⇧", code: 56),
        KeyStruct(name: "CapsLock", symbol: "⇪", code: 57),
        KeyStruct(name: "Option", symbol: "⌥", code: 58),
        KeyStruct(name: "Control", symbol: "⌃", code: 59),
        KeyStruct(name: "RightShift", symbol: "⇧", code: 60),
        KeyStruct(name: "RightOption", symbol: "⌥", code: 61),
        KeyStruct(name: "RightControl", symbol: "⌃", code: 62),
        KeyStruct(name: "Function", symbol: "fn", code: 63),
        KeyStruct(name: "F1", symbol: "F1", code: 122),
        KeyStruct(name: "F2", symbol: "F2", code: 120),
        KeyStruct(name: "F3", symbol: "F3", code: 99),
        KeyStruct(name: "F4", symbol: "F4", code: 118),
        KeyStruct(name: "F5", symbol: "F5", code: 96),
        KeyStruct(name: "F6", symbol: "F6", code: 97),
        KeyStruct(name: "F7", symbol: "F7", code: 98),
        KeyStruct(name: "F8", symbol: "F8", code: 100),
        KeyStruct(name: "F9", symbol: "F9", code: 101),
        KeyStruct(name: "F10", symbol: "F10", code: 109),
        KeyStruct(name: "F11", symbol: "F11", code: 103),
        KeyStruct(name: "F12", symbol: "F12", code: 111),
        KeyStruct(name: "F13", symbol: "F13", code: 105),
        KeyStruct(name: "BrightnessDown", symbol: "F14", code: 107),
        KeyStruct(name: "BrightnessUp", symbol: "F15", code: 113),
        KeyStruct(name: "F16", symbol: "F16", code: 106),
        KeyStruct(name: "F17", symbol: "F17", code: 64),
        KeyStruct(name: "F18", symbol: "F18", code: 79),
        KeyStruct(name: "F19", symbol: "F19", code: 80),
        KeyStruct(name: "F20", symbol: "F20", code: 90),
        KeyStruct(name: "VolumeUp", symbol: "VolumeUp", code: 72),
        KeyStruct(name: "VolumeDown", symbol: "VolumeDown", code: 73),
        KeyStruct(name: "Mute", symbol: "Mute", code: 74),
        KeyStruct(name: "Help/Insert", symbol: "Help/Insert", code: 114),
        KeyStruct(name: "Home", symbol: "⇱", code: 115),
        KeyStruct(name: "End", symbol: "⇲", code: 119),
        KeyStruct(name: "PageUp", symbol: "⇞", code: 116),
        KeyStruct(name: "PageDown", symbol: "⇟", code: 121),
        KeyStruct(name: "LeftArrow", symbol: "←", code: 123),
        KeyStruct(name: "RightArrow", symbol: "→", code: 124),
        KeyStruct(name: "DownArrow", symbol: "↓", code: 125),
        KeyStruct(name: "UpArrow", symbol: "↑", code: 126),
    ]
    
    private let key: KeyStruct
    var code: UInt8 { return self.key.code }
    var symbol: String { return self.key.symbol }
    var name: String { return self.key.name }
    static var control: Key { return Key.init(fromName: "Control")! }
    static var option: Key { return Key.init(fromName: "Option")! }
    static var shift: Key { return Key.init(fromName: "Shift")! }
    static var command: Key { return Key.init(fromName: "Command")! }
    
    init?(fromCode: UInt8) {
        for keyStruct in Key.keys {
            if fromCode != keyStruct.code { continue }
            self.key = keyStruct
            return
        }
        return nil
    }
    
    init?(fromSymbol: String) {
        let capitalizedSymbol = fromSymbol.capitalized
        for keyStruct in Key.keys {
            if capitalizedSymbol != keyStruct.symbol { continue }
            self.key = keyStruct
            return
        }
        return nil
    }
    
    init?(fromName: String) {
        let capitalizedName = fromName.capitalized
        for keyStruct in Key.keys {
            if capitalizedName != keyStruct.name { continue }
            self.key = keyStruct
            return
        }
        return nil
    }
    
    
}
