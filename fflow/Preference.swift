//
//  Preference.swift
//  fflow
//
//  Created by user on 2016/10/07.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class Preference: NSWindowController {

    private static let width: CGFloat = 600
    private static let height: CGFloat = 500

    fileprivate static let windowSize = NSSize(width: Preference.width, height: Preference.height)

    fileprivate static var windowFrame: NSRect {

        let size = Preference.windowSize

        guard let centerPoint = NSScreen.main()?.frame.centerPoint else {

            return NSRect(size: size)
        }

        return NSRect(center: centerPoint, size: size)
    }

    private static var templateWindow: NSWindow {

        return NSWindow(contentRect: Preference.windowFrame,
                        styleMask: [.closable, .titled],
                        backing: .buffered,
                        defer: false)
    }

    init() {

        super.init(window: Preference.templateWindow)

        self.window?.title = "fflow Preference"
        guard let splitView = Preference.splitView() else { return }

        self.window?.contentView?.addSubview(splitView)
//        self.window?.contentView?.addSubview(button)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func openWindow() {

        guard let window = self.window else { return }

        window.orderFront(self)
        window.becomeKey()
    }

}

private protocol HasAppsView {

    static func appsView(commandTableView: CommandTableView) -> NSView
}

extension HasAppsView where Self: Preference {

    private static var scrollViewOrigin: NSPoint { return .init(x: 0, y: 40) }
    private static var scrollViewFrame: NSRect { return .init(origin: self.scrollViewOrigin, size: .zero) }

    private static var autoresizingMask: NSAutoresizingMaskOptions {

        return [.viewHeightSizable, .viewWidthSizable, .viewMaxYMargin]
    }

    private static var scrollView: NSScrollView {

        let scrollView = NSScrollView(frame: self.scrollViewFrame)

        scrollView.borderType = .lineBorder
        scrollView.hasVerticalScroller = true
        scrollView.scrollerStyle = .overlay
        scrollView.horizontalScrollElasticity = .none
        scrollView.usesPredominantAxisScrolling = true

        scrollView.autoresizingMask = self.autoresizingMask

        return scrollView
    }

    fileprivate static func appsView(commandTableView: CommandTableView) -> NSView {

        let appTableView = AppTableView(commandTableView: commandTableView)
        let buttonBar = appTableView.buttonBarForMe

        let scrollView = self.scrollView
        scrollView.documentView = appTableView

        let view = NSView(frame: .zero)
        view.addSubview(buttonBar)
        view.addSubview(scrollView)

        view.autoresizesSubviews = true

        return view
    }
}

extension Preference: HasAppsView {}

private protocol HasCommandsView {

    static func commandsView() -> NSView
}

extension HasCommandsView where Self: Preference {

    private static var scrollViewOrigin: NSPoint { return .init(x: 0, y: 40) }
    private static var scrollViewFrame: NSRect { return .init(origin: self.scrollViewOrigin, size: .zero) }

    private static var autoresizingMask: NSAutoresizingMaskOptions {

        return [.viewHeightSizable, .viewWidthSizable, .viewMaxYMargin]
    }

    private static var scrollView: NSScrollView {

        let scrollView = NSScrollView(frame: self.scrollViewFrame)

        scrollView.borderType = .lineBorder
        scrollView.hasVerticalScroller = true
        scrollView.horizontalScrollElasticity = .none
        scrollView.usesPredominantAxisScrolling = true

        scrollView.autoresizingMask = self.autoresizingMask

        return scrollView
    }

    fileprivate static func commandsView() -> NSView {

        let commandTableView = CommandTableView()
        let buttonBar = commandTableView.buttonBarForMe

        let scrollView = self.scrollView
        scrollView.documentView = commandTableView

        let view = NSView(frame: .zero)
        view.addSubview(buttonBar)
        view.addSubview(scrollView)

        view.autoresizesSubviews = true

        return view
    }
}

extension Preference: HasCommandsView {}

private protocol HasSplitView {

     static func splitView() -> NSSplitView?
}

extension HasSplitView where Self: Preference {

    private static var splitViewFrame: NSRect {

        let topMargin: CGFloat = 40
        let bottomMargin: CGFloat = 50
        let horizontalMargin: CGFloat = 20

        let origin = NSPoint(x: horizontalMargin, y: bottomMargin)
        let size = Preference.windowFrame.insetBy(dx: horizontalMargin, dy: (topMargin + bottomMargin) / 2).size

        return NSRect(origin: origin, size: size)
    }

    fileprivate static func splitView() -> NSSplitView? {

        let appsView = Preference.appsView()
        let commandsView = Preference.commandsView()

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

extension Preference: HasSplitView {}

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

extension Preference: NSToolbarDelegate {

    private var toolbar: NSToolbar {

        let toolbar = NSToolbar(identifier: "Toolbar")
        toolbar.showsBaselineSeparator = true
        toolbar.isVisible = true
        toolbar.insertItem(withItemIdentifier: "General", at: 0)
        toolbar.delegate = self

        return toolbar
    }

    convenience init(withToolbar: Bool) {

        self.init()
        self.window?.toolbar = self.toolbar
    }

    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: String,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {

        if itemIdentifier == NSImageNamePreferencesGeneral {

            let toolbarItemGeneral = NSToolbarItem(itemIdentifier: "General")
            toolbarItemGeneral.image = NSImage(imageLiteralResourceName: NSImageNamePreferencesGeneral)
            toolbarItemGeneral.label = "General"

            return toolbarItemGeneral
        }

        return nil
    }

    func toolbarWillAddItem(_ notification: Notification) {
    }

    func toolbarDidRemoveItem(_ notification: Notification) {
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {

        return [NSImageNamePreferencesGeneral]
    }

    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [String] {

        return [NSImageNamePreferencesGeneral]
    }

    override func validateToolbarItem(_ item: NSToolbarItem) -> Bool {

        return item.itemIdentifier == NSImageNamePreferencesGeneral
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {

        return [NSImageNamePreferencesGeneral]
    }
}
