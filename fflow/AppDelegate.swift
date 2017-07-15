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

    private var preference: Preference?

    private var menuItems: [NSMenuItem] {

        let quit = NSMenuItem()
        quit.title = "Quit"
        quit.action = #selector(self.quit)

        let preferences = NSMenuItem()
        preferences.title = "Preferences"
        preferences.action = #selector(self.preferences)
        return [preferences, quit]
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Set up status bar item
        self.statusItem = StatusItem(menuItems: self.menuItems)

        // Regist event handler for scrollWheel
        NSEvent.addGlobalMonitorForEvents(
            matching: .scrollWheel,
            handler: {(event: NSEvent!) -> Void in

                guard let validScroll = ValidScroll(deltaX: event.naturalScrollingDeltaX,
                                               deltaY: event.naturalScrollingDeltaY) else {
                    return
                }

                guard let gesture = self.gesture.appendAndReleaseIfCan(direction: validScroll.direction) else { return }

                let gestureString = gesture.string

                guard gestureString != "RL" && gestureString != "LR" else {

                    Indicator.shared.showAndFadeout(gesture: gesture)
                    self.centerClick()
                    return
                }

                guard let url = NSWorkspace.shared().frontmostApplication?.bundleURL else { return }

                guard let keystrokeString = self.commandPreference.keystroke(forApp: url, gesture: gesture)
                    ?? self.commandPreference.keystroke(forApp: AppItem.Global.url, gesture: gesture) else { return }

                Indicator.shared.showAndFadeout(gesture: gesture)
                Keystroke(string: keystrokeString)?.dispatchToFrontmostApp()
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func centerClick() {

        guard let location = CGEvent(source: nil)?.location else { return }

        let down = CGEvent(mouseEventSource: nil,
                           mouseType: .otherMouseDown,
                           mouseCursorPosition: location,
                           mouseButton: .center)
        let up = CGEvent(mouseEventSource: nil,
                         mouseType: .otherMouseUp,
                         mouseCursorPosition: location,
                         mouseButton: .center)

        down?.post(tap: .cghidEventTap)
        up?.post(tap: .cghidEventTap)
    }
}

extension AppDelegate {

    func openPreferences() {

        Preference.shared.openWindow()
    }

    func quit() {

        NSApplication.shared().terminate(self)
    }
}
