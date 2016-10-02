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
    let setting = Setting()
    let gestureManager = GestureManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
//        // Initialize setting
//        setting.setGesture(appName: "Google Chrome", gesture: "dr", keyCode: 13, command: true) // command-w
//        setting.setGesture(appName: "Google Chrome", gesture: "ud", keyCode: 15, command: true) // command-r
        
        // Set status menu
        let menu = NSMenu()
        menu.addItem(makeMenuItem(title: "Quit", selector: #selector(quit)))
        statusItem.menu = menu
        statusItem.highlightMode = true
        statusItem.title = "ff"
        
        // Regist event handler for scrollWheel
        NSEvent.addGlobalMonitorForEvents(
            matching: NSEventMask.scrollWheel,
            handler: {(evt: NSEvent!) -> Void in
                
                let x = evt.scrollingDeltaX
                let y = evt.scrollingDeltaY
                let direction: String? = Direction.which(x, y: y)?.rawValue
                
                guard let gesture = self.gestureManager.add(direction: direction) else { return }
                guard let frontmostAppName = NSWorkspace.shared().frontmostApplication?.localizedName else { return }
                guard let keyStrokes = self.setting.keyStrokes[frontmostAppName] else { return }
                
                guard let keyStroke = keyStrokes[gesture] else { return }
                
                print(keyStroke)
//                var error: NSDictionary?
//                keyStroke.executeAndReturnError(&error)
        })
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
    
    
