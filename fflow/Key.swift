//
//  Key.swift
//  fflow
//
//  Created by user on 2016/10/04.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


enum Key: Int {
    
    case Num0
    case Num1
    case Num2
    case Num3
    case Num4
    case Num5
    case Num6
    case Num7
    case Num8
    case Num9
    case A
    case B
    case C
    case D
    case E
    case F
    case G
    case H
    case I
    case J
    case K
    case L
    case M
    case N
    case O
    case P
    case Q
    case R
    case S
    case T
    case U
    case V
    case W
    case X
    case Y
    case Z
    case SectionSign
    case Grave
    case Minus
    case Equal
    case LeftBracket
    case RightBracket
    case Semicolon
    case Quote
    case Comma
    case Period
    case Slash
    case Backslash
    case Keypad0
    case Keypad1
    case Keypad2
    case Keypad3
    case Keypad4
    case Keypad5
    case Keypad6
    case Keypad7
    case Keypad8
    case Keypad9
    case KeypadDecimal
    case KeypadMultiply
    case KeypadPlus
    case KeypadDivide
    case KeypadMinus
    case KeypadEquals
    case KeypadClear
    case KeypadEnter
    case Space
    case Return
    case Tab
    case Delete
    case ForwardDelete
    case Linefeed
    case Escape
    case Command
    case Shift
    case CapsLock
    case Option
    case Control
    case RightShift
    case RightOption
    case RightControl
    case Function
    case F1
    case F2
    case F3
    case F4
    case F5
    case F6
    case F7
    case F8
    case F9
    case F10
    case F11
    case F12
    case F13
    case BrightnessDown
    case BrightnessUp
    case F16
    case F17
    case F18
    case F19
    case F20
    case VolumeUp
    case VolumeDown
    case Mute
    case HelpInsert
    case Home
    case End
    case PageUp
    case PageDown
    case LeftArrow
    case RightArrow
    case DownArrow
    case UpArrow
    
    func code() -> Int {
        return [
            // number
            29, 18, 19, 20, 21, 23, 22, 26, 28, 25,
            // alphabet
            0, 11, 8, 2, 14, 3, 5, 4, 34, 38, 40, 37, 46,
            45, 31, 35, 12, 15, 1, 17, 32, 9, 13, 7, 16, 6,
            // sign
            10, 50, 27, 24, 33, 30, 41, 39, 43, 47, 44, 42,
            // keypad
            82, 83, 84, 85, 86, 87, 88, 89, 91,
            92, 65, 67, 69, 75, 78, 81, 71, 76,
            // invisible
            49, 36, 48, 51, 117, 52, 53, 55,
            56, 57, 58, 59, 60, 61, 62, 63,
            // function
            122, 120, 99, 118, 96, 97, 98, 100, 101, 109,
            103, 111, 105, 107, 113, 106, 64, 79, 80, 90,
            // system
            72, 73, 74, 114, 115, 119,
            116, 121, 123, 124, 125, 126
        ][self.rawValue]
    }

    func symbol() -> String {
        return [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
            "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
            "§", "`", "-", "=", "[", "]", ";", "'", ",", ".", "/", "\\",
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "*", "+", "/", "-", "=", "⌧", "⌤",
            "␣", "⏎", "⇥", "⌫", "⌦", "␊", "⎋", "⌘", "⇧", "⇪", "⌥", "⌃", "⇧", "⌥", "⌃", "fn",
            "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10",
            "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20",
            "VolumeUp", "VolumeDown", "Mute", "Help/Insert", "⇱", "⇲", "⇞", "⇟", "←", "→", "↓", "↑"
        ][self.rawValue]
    }
}
