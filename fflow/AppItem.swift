//
//  AppItem.swift
//  fflow
//
//  Created by user on 2017/01/01.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

enum AppItem {

    case Global
    case Finder
    case Else(URL)

    private static var globalIconImage: NSImage {

        guard let image = NSImage(named: NSImageNameComputer) else { return NSImage() }
        return image
    }

    var name: String {

        switch self {
        case .Global: return "Global"
        case .Finder: return "Finder.app"
        case let .Else(url): return url.lastPathComponent
        }
    }

    var path: String {

        switch self {
        case .Global: return "/"
        case .Finder: return "/System/Library/CoreServices/Finder.app"
        case let .Else(url): return url.path
        }
    }
    
    var iconImage: NSImage? {

        switch self {
        case .Global: return AppItem.globalIconImage
        default: return NSWorkspace.shared().icon(forFile: self.path)
        }
    }
}
