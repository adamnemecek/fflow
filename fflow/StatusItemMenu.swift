//
//  StatusItemMenu.swift
//  fflow
//
//  Created by user on 2017/07/14.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

enum StatusItemMenu: String {

    case Preferences
    case Quit

    var action: Selector {

        switch self {
        case .Preferences: return #selector(AppDelegate.openPreferences)
        case .Quit:        fallthrough
        default:           return #selector(AppDelegate.quit)
        }
    }

    var item: NSMenuItem {

        let item = NSMenuItem()
        item.title = self.rawValue
        item.action = self.action

        return item
    }
}
