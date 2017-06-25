//
//  AppColumn.swift
//  fflow
//
//  Created by user on 2017/01/08.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

enum AppColumn: String {

    case AppIcon
    case AppName

    var identifier: String {

        return self.rawValue
    }

    var width: CGFloat {

        switch self {
        case .AppIcon: return 40
        case .AppName: return 150
        }
    }

    var tableColumn: NSTableColumn {

        let tableColumn = NSTableColumn(identifier: self.identifier)
        tableColumn.width = self.width
        return tableColumn
    }
}

extension AppColumn {

    private var imageViewWidth: CGFloat { return AppColumn.AppIcon.width }
    private var imageViewSize: NSSize { return NSSize(squaringOf: self.imageViewWidth) }
    private var imageViewFrame: NSRect { return NSRect(size: self.imageViewSize) }

    private var imageMargin: CGFloat { return 5 }
    private var imageSize: NSSize { return self.imageViewSize.insetBy(bothDxDy: self.imageMargin) }

    private func imageView(image: NSImage?) -> NSImageView {

        let imageView = NSImageView(frame: self.imageViewFrame)

        guard let image = image else { return imageView }

        image.size = self.imageSize

        imageView.image = image

        return imageView
    }

    private var fontSize: CGFloat { return 13 }

    private var textFieldWidth: CGFloat { return AppColumn.AppName.width }
    private var textFieldOrigin: NSPoint { return NSPoint(x: self.imageViewWidth, y: 0) }
    private var textFieldSize: NSSize { return NSSize(width: self.textFieldWidth, height: 0) }
    private var textFieldFrame: NSRect { return NSRect(origin: self.textFieldOrigin, size:self.textFieldSize) }

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

    static var appPaths: [String] {

        let appPaths = CommandPreference().appPaths.filter({
            $0 != AppItem.Global.path && $0 != AppItem.Finder.path
        })

        return [AppItem.Global.path] + [AppItem.Finder.path] + appPaths
    }

    fileprivate static func appItem(at row: Int) -> AppItem {

        switch row {
        case 0: return AppItem.Global
        case 1: return AppItem.Finder
        default: return AppItem.Else(URL(fileURLWithPath: AppColumn.appPaths[row]))
        }
    }

    func view(at row: Int) -> NSView? {

        let appItem = AppColumn.appItem(at: row)

        switch self {
        case .AppIcon: return self.imageView(image: appItem.iconImage)
        case .AppName: return self.textField(string: appItem.name)
        }
    }
}

extension AppColumn {

    static var rowCount: Int {

        return self.appPaths.count
    }

    static func path(at row: Int) -> String {

        return self.appPaths[row]
    }

    static func appName(at row: Int) -> String {

        return self.appItem(at: row).name
    }
}
