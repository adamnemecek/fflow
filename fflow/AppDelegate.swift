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
    let gestureCommandManager = GestureCommandManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Initialize setting
        let cmdW = Keystroke(keyCode: 13, command: true) // command-w
        let dr = Gesture(fromString: "dr")
        let drCmdW = GestureCommand(gesture: dr, keystroke: cmdW)
        gestureCommandManager.append(appName: "Google Chrome", gestureCommand: drCmdW)
        let cmdR = Keystroke(keyCode: 15, command: true) // command-r
        let ud = Gesture(fromString: "ud")
        let udCmdR = GestureCommand(gesture: ud, keystroke: cmdR)
        gestureCommandManager.append(appName: "Google Chrome", gestureCommand: udCmdR)
        
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
                let direction: Direction? = Direction.which(x, y: y)
                
                guard let gesture = self.gestureProcessor.append(direction: direction) else { return }
                guard let frontmostAppName = NSWorkspace.shared().frontmostApplication?.localizedName else { return }
                guard let keystroke = self.gestureCommandManager.getKeystroke(appName: frontmostAppName, gesture: gesture) else { return }
                
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
    
    
