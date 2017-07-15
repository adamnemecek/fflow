//
//  Preference.swift
//  fflow
//
//  Created by user on 2016/10/07.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class Preference {

    static fileprivate let width: CGFloat = 600
    static private let height: CGFloat = 500

    static fileprivate let windowSize = NSSize(width: Preference.width, height: Preference.height)

    static fileprivate var windowFrame: NSRect {

        let size = Preference.windowSize

        guard let centerPoint = NSScreen.main()?.frame.centerPoint else {

            return NSRect(size: size)
        }

        return NSRect(center: centerPoint, size: size)
    }

    static private var templateWindow: NSWindow {

        let window =  NSWindow(contentRect: Preference.windowFrame,
                               styleMask: [.closable, .titled],
                               backing: .buffered,
                               defer: false)

        window.title = "fflow Preference"

        return window
    }

    static let shared = Preference()

    fileprivate let window = Preference.templateWindow

    private init() {}
}

private protocol HasAppsView {}

extension HasAppsView where Self: Preference {

    static private var scrollViewOrigin: NSPoint { return NSPoint(x: 0, y: 40) }

    static private var scrollViewFrame: NSRect {

        return NSRect(origin: self.scrollViewOrigin, size: .zero)
    }

    static private var autoresizingMask: NSAutoresizingMaskOptions {

        return [.viewHeightSizable, .viewWidthSizable, .viewMaxYMargin]
    }

    static private var scrollView: NSScrollView {

        let scrollView = NSScrollView(frame: self.scrollViewFrame)

        scrollView.borderType = .lineBorder
        scrollView.hasVerticalScroller = true
        scrollView.scrollerStyle = .overlay
        scrollView.horizontalScrollElasticity = .none
        scrollView.usesPredominantAxisScrolling = true

        scrollView.autoresizingMask = self.autoresizingMask

        return scrollView
    }

    static fileprivate func appsView() -> NSView {

        let scrollView = self.scrollView
        let appTableView = AppTableView()
        scrollView.documentView = appTableView

        let view = NSView(frame: .zero)
        view.addSubview(scrollView)
        view.addSubview(appTableView.buttonBarForMe)

        view.autoresizesSubviews = true

        return view
    }
}

private protocol HasCommandsView {}

extension HasCommandsView where Self: Preference {

    static private var scrollViewOrigin: NSPoint { return NSPoint(x: 0, y: 40) }

    static private var scrollViewFrame: NSRect {

        return NSRect(origin: self.scrollViewOrigin, size: .zero)
    }

    static private var autoresizingMask: NSAutoresizingMaskOptions {

        return [.viewHeightSizable, .viewWidthSizable, .viewMaxYMargin]
    }

    static private var scrollView: NSScrollView {

        let scrollView = NSScrollView(frame: self.scrollViewFrame)

        scrollView.borderType = .lineBorder
        scrollView.hasVerticalScroller = true
        scrollView.horizontalScrollElasticity = .none
        scrollView.usesPredominantAxisScrolling = true

        scrollView.autoresizingMask = self.autoresizingMask

        return scrollView
    }

    static fileprivate func commandsView() -> NSView {

        let scrollView = self.scrollView
        let commandTableView = CommandTableView()
        scrollView.documentView = commandTableView

        let view = NSView(frame: .zero)
        view.addSubview(scrollView)
        view.addSubview(commandTableView.buttonBarForMe)

        view.autoresizesSubviews = true

        return view
    }
}

private protocol HasSplitView: HasAppsView, HasCommandsView {}

extension HasSplitView where Self: Preference {

    static private var splitViewFrame: NSRect {

        let topMargin: CGFloat = 40
        let bottomMargin: CGFloat = 50
        let horizontalMargin: CGFloat = 20

        let origin = NSPoint(x: horizontalMargin, y: bottomMargin)
        let size = Preference.windowFrame.insetBy(dx: horizontalMargin, dy: (topMargin + bottomMargin) / 2).size

        return NSRect(origin: origin, size: size)
    }

    static fileprivate func splitView() -> NSSplitView? {

        let appsView = self.appsView()
        let commandsView = self.commandsView()

        let splitView = NSSplitView(frame: self.splitViewFrame)
        splitView.addArrangedSubview(appsView)
        splitView.addArrangedSubview(commandsView)
        splitView.isVertical = true

        let leftSize = NSSize(width: 3, height: 0)
        let rightSize = NSSize(width: 4, height: 0)

        splitView.arrangedSubviews[0].setFrameSize(leftSize)
        splitView.arrangedSubviews[1].setFrameSize(rightSize)
        splitView.adjustSubviews()

        return splitView
    }
}

private protocol HasDoneButton {}

extension HasDoneButton where Self: Preference {

    static private var doneButtonWidth: CGFloat { return 80 }
    static private var doneButtonHeight: CGFloat { return 20 }

    static private var doneButtonRightMargin: CGFloat { return 20 }
    static private var doneButtonBottomMargin: CGFloat { return 10 }

    static private var doneButtonOrigin: NSPoint {

        return NSPoint(x: self.width - self.doneButtonRightMargin - self.doneButtonWidth,
                       y: self.doneButtonBottomMargin)
    }
    static private var doneButtonSize: NSSize {

        return NSSize(width: self.doneButtonWidth,
                      height: self.doneButtonHeight)
    }
    static private var doneButtonFrame: NSRect {

        return NSRect(origin: self.doneButtonOrigin,
                      size: self.doneButtonSize)
    }
    static fileprivate var doneButton: NSButton {

        let button = NSButton(frame: self.doneButtonFrame)

        button.title = "Done"
        button.bezelStyle = .roundRect

        button.action = #selector(self.shared.window.close)

        return button
    }
}

private protocol CanOpen: HasSplitView, HasDoneButton {

    func openWindow()
}

extension Preference: CanOpen {

    func openWindow() {

        guard let splitView = Preference.splitView() else { return }

        let window = Preference.shared.window

        window.contentView?.addSubview(Preference.doneButton)
        window.contentView?.addSubview(splitView)

        window.orderFrontRegardless()
        window.becomeKey()
    }
}

protocol CanClear {

    func clearCompletely()
}

extension CanClear where Self: Preference {

    func clearCompletely() {

        let userDefaults = NSUserDefaultsController().defaults

        guard let domainName = Bundle.main.bundleIdentifier else { return }
        guard let items = userDefaults.persistentDomain(forName: domainName) else { return }

        let keys = Array(items.keys)
        keys.forEach({ userDefaults.removeObject(forKey: $0) })
    }
}

extension Preference: CanClear {}
