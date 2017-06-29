//
//  GestureColumn.swift
//  fflow
//
//  Created by user on 2017/01/08.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

enum CommandColumn: String {

    case GesturePath
    case GestureArrowString
    case Keystroke

    var identifier: String {

        return self.rawValue
    }

    var width: CGFloat {

        switch self {
        case .GesturePath:        return 40
        case .GestureArrowString: return 80
        case .Keystroke:          return 0
        }
    }

    var tableColumn: NSTableColumn {

        let tableColumn = NSTableColumn(identifier: self.identifier)
        tableColumn.width = self.width
        return tableColumn
    }

    private var imageViewWidth: CGFloat { return CommandColumn.GesturePath.width }
    private var imageViewSize: NSSize { return NSSize(squaringOf: self.imageViewWidth) }
    private var imageViewFrame: NSRect { return NSRect(size: self.imageViewSize) }

    private var imageMargin: CGFloat { return 0 }
    private var imageSize: NSSize { return self.imageViewSize.insetBy(bothDxDy: self.imageMargin) }

    private func imageView(for gesture: Gesture) -> NSImageView {

        let image = Indicator.image(by: gesture.path)
        image.size = self.imageSize
        image.isTemplate = true

        let imageView = NSImageView(frame: self.imageViewFrame)
        imageView.image = image

        return imageView
    }

    private var fontSize: CGFloat { return 13 }

    private var textFieldWidth: CGFloat { return CommandColumn.GestureArrowString.width }
    private var textFieldSize: NSSize { return NSSize(width: self.textFieldWidth, height: 0) }
    private var textFieldFrame: NSRect { return NSRect(size: self.textFieldSize) }

    private func textField(for gesture: Gesture) -> NSTextField {

        let textField = NSTextField(frame: self.textFieldFrame)
        textField.backgroundColor = .clear
        textField.font = NSFont.boldSystemFont(ofSize: self.fontSize)
        textField.isBordered = false
        textField.isSelectable = false
        textField.isEditable = false
        textField.usesSingleLineMode = true

        textField.stringValue = gesture.arrowString

        return textField
    }

    private func keystrokeListener(forApp path: String, gestureString: String) -> KeystrokeListener {

        let keystrokeListener = KeystrokeListener(frame: NSRect(width: self.width, height: 0))

        let keystrokeString = CommandPreference().keystroke(forApp: path, gestureString: gestureString)
        keystrokeListener.set(keystrokeString: keystrokeString ?? "")

        keystrokeListener.afterUnlisten = {(_ keystroke: Keystroke?) -> Void in
            CommandPreference().set(forApp: path,
                                    gestureString: gestureString,
                                    keystrokeString: keystroke?.string ?? "")
        }

        return keystrokeListener
    }

    func view(forApp path: String, at row: Int) -> NSView? {

        let gestureString = CommandPreference().gestures(forApp: path)[row]
        let gesture = Gesture(string: gestureString)

        switch self {
        case .GesturePath:
            return self.imageView(for: gesture)
        case .GestureArrowString:
            return self.textField(for: gesture)
        case .Keystroke:
            return self.keystrokeListener(forApp: path, gestureString: gestureString)
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
