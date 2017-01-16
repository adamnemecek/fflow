//
//  GestureColumn.swift
//  fflow
//
//  Created by user on 2017/01/08.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

enum CommandColumn: String {

    case Gesture
    case Keystroke

    var identifier: String {

        return self.rawValue
    }

    var width: CGFloat {

        switch self {
        case .Gesture: return 80
        case .Keystroke: return 80
        }
    }

    var tableColumn: NSTableColumn {

        let tableColumn = NSTableColumn(identifier: self.identifier)
        tableColumn.width = self.width
        return tableColumn
    }

    private var fontSize: CGFloat { return 13 }

    private var textFieldWidth: CGFloat { return CommandColumn.Gesture.width }
    private var textFieldSize: NSSize { return NSSize(width: self.textFieldWidth, height: 0) }
    private var textFieldFrame: NSRect { return NSRect(size:self.textFieldSize) }

    private func textField(string: String) -> NSTextField {

        let textField = NSTextField(frame: self.textFieldFrame)
        textField.backgroundColor = .clear
        textField.font = NSFont.boldSystemFont(ofSize: self.fontSize)
        textField.isBordered = false
        textField.stringValue = string
        textField.isSelectable = false
        textField.isEditable = false
        textField.usesSingleLineMode = true

        return textField
    }

    private func keystrokeListener(keystrokeString: String) -> KeystrokeListener {

        let keystrokeListener = KeystrokeListener(frame: .init(width: self.width, height: 0))
        keystrokeListener.set(keystrokeString: keystrokeString)

        return keystrokeListener
    }

    func view(forApp path: String, at row: Int) -> NSView? {

        let commandPreference = CommandPreference()
        let gestureString = commandPreference.gestures(forApp: path)[row]

        switch self {
        case .Gesture:
            return self.textField(string: gestureString)
        case .Keystroke:
            let keystrokeString = commandPreference.keystroke(forApp: path, gestureString: gestureString)
            let keystrokeListener = self.keystrokeListener(keystrokeString: keystrokeString ?? "")
            let handler = {() -> Void in
                guard let keystroke = keystrokeListener.keystroke else { return }
                CommandPreference().set(forApp: path, gestureString: gestureString, keystrokeString: keystroke.string)
            }
            keystrokeListener.afterUnlisten(handler: handler)
            return keystrokeListener
        }
    }
}

extension CommandColumn {

    static func rowCount(forApp path: String) -> Int {

        return CommandPreference().gestures(forApp: path).count
    }
}

extension CommandColumn {

    static func gestureString(forApp path: String, at row: Int) -> String {

        return CommandPreference().gestures(forApp: path)[row]
    }
}
