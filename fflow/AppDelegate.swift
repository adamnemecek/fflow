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
    let gestureProcessor = GestureProcessor()
    let gestureCommandsManager = GestureCommandsManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Initialize setting
        let gestureCommandsForApp = GestureCommandsForApp(appName: "Google Chrome")
        gestureCommandsForApp.append(gestureString: "dur", keystrokeString: "command-t")
        gestureCommandsForApp.append(gestureString: "dr", keystrokeString: "command-w")
        gestureCommandsForApp.append(gestureString: "dru", keystrokeString: "shift-command-t")
        gestureCommandsForApp.append(gestureString: "lurd", keystrokeString: "command-r")
        gestureCommandsForApp.append(gestureString: "ur", keystrokeString: "option-command-→")
        gestureCommandsForApp.append(gestureString: "ul", keystrokeString: "option-command-←")
        gestureCommandsManager.append(gestureCommandsForApp: gestureCommandsForApp)
        
        // Set status menu
        let image = NSImage(named: "32")
        image?.isTemplate = true
        image?.size = NSSize(width: 18, height: 18)
        statusItem.image = image
        let menu = NSMenu()
        menu.addItem(makeMenuItem(title: "Quit", selector: #selector(quit)))
        statusItem.menu = menu
        statusItem.highlightMode = true
//        statusItem.title = "ff"
        
        // Regist event handler for scrollWheel
        NSEvent.addGlobalMonitorForEvents(
            matching: NSEventMask.scrollWheel,
            handler: {(evt: NSEvent!) -> Void in
                
                let x = evt.scrollingDeltaX
                let y = evt.scrollingDeltaY
                let direction: Direction? = Direction.which(x, y: y)
                
                guard let gesture = self.gestureProcessor.append(direction: direction) else { return }
                guard let frontmostAppName = NSWorkspace.shared().frontmostApplication?.localizedName else { return }
                guard let keystroke = self.gestureCommandsManager.getKeystroke(appName: frontmostAppName, gesture: gesture) else { return }
                
                keystroke.dispatchTo(appName: frontmostAppName)
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
