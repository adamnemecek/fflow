//
//  AppTableView.swift
//  fflow
//
//  Created by user on 2017/01/01.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

public extension NSNotification.Name {

    static let AppTableSelectionChanged = NSNotification.Name("AppTableSelectionChanged")
}

class AppTableView: NSTableView {

    init() {

        super.init(frame: .zero)

        self.rowHeight = AppColumn.AppIcon.width
        self.headerView = nil
        self.focusRingType = .none
        self.allowsEmptySelection = false
        self.intercellSpacing = NSSize(squaringOf: 5)

        self.delegate = self
        self.dataSource = self

        self.addTableColumn(AppColumn.AppIcon.tableColumn)
        self.addTableColumn(AppColumn.AppName.tableColumn)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}

extension AppTableView: NSTableViewDelegate {

    private func noticeSelectionChanged(selectedAt row: Int) {

        NotificationCenter.default.post(name: .AppTableSelectionChanged,
                                        object: AppColumn.path(at: row),
                                        userInfo: nil)
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let identifier = tableColumn?.identifier else { return nil }
        guard let appColumn = AppColumn(rawValue: identifier) else { return nil }

        return appColumn.view(at: row)
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {

        self.noticeSelectionChanged(selectedAt: row)

        return true
    }
}

extension AppTableView: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {

        return AppColumn.rowCount
    }
}

extension AppTableView: CanSelect {}

extension AppTableView: HasButtonBar {

    private func handlerToAddApp(for openPanel: NSOpenPanel) -> ((NSModalResponse) -> Void) {

        return {(modalResponse: NSModalResponse) -> Void in

            guard modalResponse == NSModalResponseOK else { return }
            guard let path = openPanel.url?.path else { return }

            CommandPreference().setApp(path: path)
            self.reloadData()

            self.selectLastRow()
        }
    }

    private var templateOpenPanel: NSOpenPanel {

        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.canCreateDirectories = false
        openPanel.directoryURL = URL(fileURLWithPath: "/Applications", isDirectory: true)
        openPanel.allowedFileTypes = ["app"]

        return openPanel
    }

    func add() {

        guard let window = self.window else { return }

        let openPanel = self.templateOpenPanel
        openPanel.beginSheetModal(for: window,
                                  completionHandler: self.handlerToAddApp(for: openPanel))
    }

    private func removeApp(at row: Int) {

        let commandPreference = CommandPreference()
        let path = AppColumn.appPaths[row]
        commandPreference.removeApp(path: path)
    }

    private func confirmationAlert(for row: Int) -> NSAlert {

        let appName = AppColumn.appName(at: row)
        let alert = NSAlert()
        alert.addButton(withTitle: "Remove")
        alert.addButton(withTitle: "Cancel")
        alert.informativeText = "Remove \(appName) ?"

        return alert
    }

    private var unremovableApps: [AppItem] { return [.Global, .Finder] }

    private func canRemove(this row: Int) -> Bool {

        return row >= self.unremovableApps.count
    }

    private var responseRemove: Int { return 1000 }

    private func handlerToRemoveApp(at row: Int) -> ((NSModalResponse) -> Void) {

        return {(modalResponse: NSModalResponse) -> Void in

            guard modalResponse == self.responseRemove else { return }

            self.removeApp(at: row)

            self.reloadData()
        }
    }

    func removeSelected() {

        let row = self.selectedRow

        guard self.canRemove(this: row) else { return }

        guard let window = self.window else { return }

        self.confirmationAlert(for: row)
            .beginSheetModal(for: window,
                             completionHandler: self.handlerToRemoveApp(at: row))
    }

    func buttonBarClicked(sender: Any?) {

        guard let segmentedControl = sender as? NSSegmentedControl else { return }

        switch segmentedControl.selectedSegment {
        case self.addSegment: self.add()
        case self.removeSegment: self.removeSelected()
        default: break
        }
    }

    var buttonBarForMe: NSSegmentedControl {

        let buttonBar = self.buttonBar
        buttonBar.action = #selector(buttonBarClicked(sender:))

        return buttonBar
    }
}
