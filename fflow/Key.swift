//
//  Key.swift
//  fflow
//
//  Created by user on 2016/10/09.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


enum Key: Int {

    case Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine

    case A, B, C, D, E, F, G, H, I, J, K, L, M, N
    case O, P, Q, R, S, T, U, V, W, X, Y, Z

    case SectionSign, Grave, Minus, Equal
    case LeftBracket, RightBracket, Semicolon
    case Quote, Comma, Period, Slash, Backslash

    case Keypad0, Keypad1, Keypad2, Keypad3, Keypad4
    case Keypad5, Keypad6, Keypad7, Keypad8, Keypad9
    case KeypadDecimal, KeypadMultiply, KeypadPlus, KeypadDivide
    case KeypadMinus, KeypadEquals, KeypadClear, KeypadEnter

    case Space, Return, Tab, Delete, ForwardDelete, Linefeed, Escape
    case Command, Shift, CapsLock, Option, Control
    case RightShift, RightOption, RightControl, Function

    case F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12
    case F13, BrightnessDown, BrightnessUp, F16, F17, F18, F19, F20

    case VolumeUp, VolumeDown, Mute, HelpInsert
    case Home, End, PageUp, PageDown
    case LeftArrow, RightArrow, DownArrow, UpArrow


    static private func find(which here: (KeyInfo) -> Bool) -> Key? {

        guard let rawValue = keyInfos.index(where: here) else { return nil }
        return Key(rawValue: rawValue)
    }

    var name: String {
        return keyInfos[self.rawValue].name
    }

    var code: CGKeyCode {
        return keyInfos[self.rawValue].code
    }

    var symbol: String {
        return keyInfos[self.rawValue].symbol
    }

    init?(fromName name: String) {

        let which: (KeyInfo) -> Bool = { $0.name == name.capitalized }
        guard let key = Key.find(which: which) else { return nil }
        self = key
    }

    init?(fromSymbol symbol: String) {

        let which: (KeyInfo) -> Bool = { $0.symbol == symbol.capitalized }
        guard let key = Key.find(which: which) else { return nil }
        self = key
    }

    init?(fromCode code: CGKeyCode) {

        let which: (KeyInfo) -> Bool = { $0.code == code }
        guard let key = Key.find(which: which) else { return nil }
        self = key
    }
}


private struct KeyInfo {

    let name: String
    let symbol: String
    let code: CGKeyCode
}


private let keyInfos = [
    KeyInfo(name: "Zero", symbol: "0", code: 29),
    KeyInfo(name: "One", symbol: "1", code: 18),
    KeyInfo(name: "Two", symbol: "2", code: 19),
    KeyInfo(name: "Three", symbol: "3", code: 20),
    KeyInfo(name: "Four", symbol: "4", code: 21),
    KeyInfo(name: "Five", symbol: "5", code: 23),
    KeyInfo(name: "Six", symbol: "6", code: 22),
    KeyInfo(name: "Seven", symbol: "7", code: 26),
    KeyInfo(name: "Eight", symbol: "8", code: 28),
    KeyInfo(name: "Nine", symbol: "9", code: 25),
    KeyInfo(name: "A", symbol: "A", code: 0),
    KeyInfo(name: "B", symbol: "B", code: 11),
    KeyInfo(name: "C", symbol: "C", code: 8),
    KeyInfo(name: "D", symbol: "D", code: 2),
    KeyInfo(name: "E", symbol: "E", code: 14),
    KeyInfo(name: "F", symbol: "F", code: 3),
    KeyInfo(name: "G", symbol: "G", code: 5),
    KeyInfo(name: "H", symbol: "H", code: 4),
    KeyInfo(name: "I", symbol: "I", code: 34),
    KeyInfo(name: "J", symbol: "J", code: 38),
    KeyInfo(name: "K", symbol: "K", code: 40),
    KeyInfo(name: "L", symbol: "L", code: 37),
    KeyInfo(name: "M", symbol: "M", code: 46),
    KeyInfo(name: "N", symbol: "N", code: 45),
    KeyInfo(name: "O", symbol: "O", code: 31),
    KeyInfo(name: "P", symbol: "P", code: 35),
    KeyInfo(name: "Q", symbol: "Q", code: 12),
    KeyInfo(name: "R", symbol: "R", code: 15),
    KeyInfo(name: "S", symbol: "S", code: 1),
    KeyInfo(name: "T", symbol: "T", code: 17),
    KeyInfo(name: "U", symbol: "U", code: 32),
    KeyInfo(name: "V", symbol: "V", code: 9),
    KeyInfo(name: "W", symbol: "W", code: 13),
    KeyInfo(name: "X", symbol: "X", code: 7),
    KeyInfo(name: "Y", symbol: "Y", code: 16),
    KeyInfo(name: "Z", symbol: "Z", code: 6),
    KeyInfo(name: "SectionSign", symbol: "§", code: 10),
    KeyInfo(name: "Grave", symbol: "`", code: 50),
    KeyInfo(name: "Minus", symbol: "-", code: 27),
    KeyInfo(name: "Equal", symbol: "=", code: 24),
    KeyInfo(name: "LeftBracket", symbol: "[", code: 33),
    KeyInfo(name: "RightBracket", symbol: "]", code: 30),
    KeyInfo(name: "Semicolon", symbol: ";", code: 41),
    KeyInfo(name: "Quote", symbol: "'", code: 39),
    KeyInfo(name: "Comma", symbol: ",", code: 43),
    KeyInfo(name: "Period", symbol: ".", code: 47),
    KeyInfo(name: "Slash", symbol: "/", code: 44),
    KeyInfo(name: "Backslash", symbol: "\\", code: 42),
    KeyInfo(name: "Keypad0", symbol: "0", code: 82),
    KeyInfo(name: "Keypad1", symbol: "1", code: 83),
    KeyInfo(name: "Keypad2", symbol: "2", code: 84),
    KeyInfo(name: "Keypad3", symbol: "3", code: 85),
    KeyInfo(name: "Keypad4", symbol: "4", code: 86),
    KeyInfo(name: "Keypad5", symbol: "5", code: 87),
    KeyInfo(name: "Keypad6", symbol: "6", code: 88),
    KeyInfo(name: "Keypad7", symbol: "7", code: 89),
    KeyInfo(name: "Keypad8", symbol: "8", code: 91),
    KeyInfo(name: "Keypad9", symbol: "9", code: 92),
    KeyInfo(name: "KeypadDecimal", symbol: ".", code: 65),
    KeyInfo(name: "KeypadMultiply", symbol: "*", code: 67),
    KeyInfo(name: "KeypadPlus", symbol: "+", code: 69),
    KeyInfo(name: "KeypadDivide", symbol: "/", code: 75),
    KeyInfo(name: "KeypadMinus", symbol: "-", code: 78),
    KeyInfo(name: "KeypadEquals", symbol: "=", code: 81),
    KeyInfo(name: "KeypadClear", symbol: "⌧", code: 71),
    KeyInfo(name: "KeypadEnter", symbol: "⌤", code: 76),
    KeyInfo(name: "Space", symbol: "␣", code: 49),
    KeyInfo(name: "Return", symbol: "⏎", code: 36),
    KeyInfo(name: "Tab", symbol: "⇥", code: 48),
    KeyInfo(name: "Delete", symbol: "⌫", code: 51),
    KeyInfo(name: "ForwardDelete", symbol: "⌦", code: 117),
    KeyInfo(name: "Linefeed ?", symbol: "␊", code: 52),
    KeyInfo(name: "Escape", symbol: "⎋", code: 53),
    KeyInfo(name: "Command", symbol: "⌘", code: 55),
    KeyInfo(name: "Shift", symbol: "⇧", code: 56),
    KeyInfo(name: "CapsLock", symbol: "⇪", code: 57),
    KeyInfo(name: "Option", symbol: "⌥", code: 58),
    KeyInfo(name: "Control", symbol: "⌃", code: 59),
    KeyInfo(name: "RightShift", symbol: "⇧", code: 60),
    KeyInfo(name: "RightOption", symbol: "⌥", code: 61),
    KeyInfo(name: "RightControl", symbol: "⌃", code: 62),
    KeyInfo(name: "Function", symbol: "fn", code: 63),
    KeyInfo(name: "F1", symbol: "F1", code: 122),
    KeyInfo(name: "F2", symbol: "F2", code: 120),
    KeyInfo(name: "F3", symbol: "F3", code: 99),
    KeyInfo(name: "F4", symbol: "F4", code: 118),
    KeyInfo(name: "F5", symbol: "F5", code: 96),
    KeyInfo(name: "F6", symbol: "F6", code: 97),
    KeyInfo(name: "F7", symbol: "F7", code: 98),
    KeyInfo(name: "F8", symbol: "F8", code: 100),
    KeyInfo(name: "F9", symbol: "F9", code: 101),
    KeyInfo(name: "F10", symbol: "F10", code: 109),
    KeyInfo(name: "F11", symbol: "F11", code: 103),
    KeyInfo(name: "F12", symbol: "F12", code: 111),
    KeyInfo(name: "F13", symbol: "F13", code: 105),
    KeyInfo(name: "BrightnessDown", symbol: "F14", code: 107),
    KeyInfo(name: "BrightnessUp", symbol: "F15", code: 113),
    KeyInfo(name: "F16", symbol: "F16", code: 106),
    KeyInfo(name: "F17", symbol: "F17", code: 64),
    KeyInfo(name: "F18", symbol: "F18", code: 79),
    KeyInfo(name: "F19", symbol: "F19", code: 80),
    KeyInfo(name: "F20", symbol: "F20", code: 90),
    KeyInfo(name: "VolumeUp", symbol: "VolumeUp", code: 72),
    KeyInfo(name: "VolumeDown", symbol: "VolumeDown", code: 73),
    KeyInfo(name: "Mute", symbol: "Mute", code: 74),
    KeyInfo(name: "Help/Insert", symbol: "Help/Insert", code: 114),
    KeyInfo(name: "Home", symbol: "⇱", code: 115),
    KeyInfo(name: "End", symbol: "⇲", code: 119),
    KeyInfo(name: "PageUp", symbol: "⇞", code: 116),
    KeyInfo(name: "PageDown", symbol: "⇟", code: 121),
    KeyInfo(name: "LeftArrow", symbol: "←", code: 123),
    KeyInfo(name: "RightArrow", symbol: "→", code: 124),
    KeyInfo(name: "DownArrow", symbol: "↓", code: 125),
    KeyInfo(name: "UpArrow", symbol: "↑", code: 126),
]
