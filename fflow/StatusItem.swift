//
//  StatusItemImage.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class StatusItem {

    static private var menuItems: [NSMenuItem] {

        return [StatusItemMenu.Preferences.item,
                StatusItemMenu.Quit.item]
    }

    static let shared = StatusItem()

    private let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

    private init() {

        let menu = NSMenu()
        StatusItem.menuItems.forEach({ menu.addItem($0) })

        self.statusItem.menu = menu
        self.statusItem.highlightMode = true
        self.statusItem.image = StatusItemIcon.icon()
    }
}
