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


    private var statusItem: StatusItem? = nil
    
    private let indicator: Indicator = Indicator()
    private let gesture = Gesture()
    private let commandPreference = CommandPreference()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Set up status bar item
        self.statusItem = StatusItem(menuItems: self.menuItems)
        
        // Regist event handler for scrollWheel
        NSEvent.addGlobalMonitorForEvents(
            matching: NSEventMask.scrollWheel,
            handler: {(evt: NSEvent!) -> Void in
                
                self.gesture.append(x: evt.scrollingDeltaX,
                                    y: evt.scrollingDeltaY)

                guard let gestureString = self.gesture.release() else { return }
                
                guard let frontmostApp = NSWorkspace.shared().frontmostApplication else { return }
                guard let url = frontmostApp.bundleURL else { return }
                
                guard let keystrokeString = self.commandPreference.keystroke(forApp: url.path, gestureString: gestureString, includesGlobal: true) else { return }
                
                self.indicator.showAndFadeout(gesture: Gesture(fromString: gestureString))

                guard let appName = frontmostApp.localizedName else { return }
                guard let keystroke = Keystroke(fromString: keystrokeString) else { return }

                keystroke.dispatchTo(appName: appName)
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private var menuItems: [NSMenuItem] {

        let quit = NSMenuItem()
        quit.title = "Quit"
        quit.action = #selector(self.quit)
        return [quit]
    }

    @objc private func quit() {

        NSApplication.shared().terminate(self)
    }
}
