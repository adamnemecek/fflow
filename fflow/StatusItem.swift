//
//  StatusItemImage.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class StatusItem {

    static private var iconImageName: String { return "StatusItemIcon" }
    static private var iconImage: NSImage? { return NSImage(named: self.iconImageName) }

    static private var size: NSSize { return NSSize(squaringOf: 18) }

    static private var icon: NSImage {

        guard let image = self.iconImage else { return NSImage.init() }
        image.isTemplate = true
        image.size = self.size
        return image
    }

    static private var menuItems: [NSMenuItem] {

        return [StatusItemMenu.Preferences.item,
                StatusItemMenu.Quit.item]
    }

    static private var menu: NSMenu {

        let menu = NSMenu()
        self.menuItems.forEach({ menu.addItem($0) })
        return menu
    }

    static private var templateStatusItem: NSStatusItem {

        let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        statusItem.menu = self.menu
        statusItem.highlightMode = true
        statusItem.image = self.icon
        return statusItem
    }

    static let shared = StatusItem()

    private let statusItem: NSStatusItem

    private init() {

        self.statusItem = StatusItem.templateStatusItem
    }
}
