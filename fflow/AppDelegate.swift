//
//  AppDelegate.swift
//  fflow
//
//  Created by user on 2016/09/30.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let menu = NSMenu()
        menu.addItem(makeMenuItem(title: "Quit", selector: #selector(quit)))
        
        statusItem.menu = menu
        statusItem.highlightMode = true
        statusItem.title = "ff"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func makeMenuItem(title: String, selector: Selector?) -> NSMenuItem {
        let menuItem = NSMenuItem()
        menuItem.title = title
        menuItem.action = selector
        return menuItem
    }
    
    func quit() {
        NSApplication.shared().terminate(self)
    }
    
}
    
    
