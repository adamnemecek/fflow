//
//  AppTableView.swift
//  fflow
//
//  Created by user on 2017/01/01.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

public extension NSNotification.Name {

    static let AppTableSelectionChenged = NSNotification.Name("AppTableSelectionChanged")
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

        NotificationCenter.default.post(name: .AppTableSelectionChenged,
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

    private func letUserChooseApp() -> URL? {

        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.canCreateDirectories = false
        openPanel.directoryURL = URL(fileURLWithPath: "/Applications", isDirectory: true)
        openPanel.allowedFileTypes = ["app"]

        let modalResponse = openPanel.runModal()

        guard modalResponse == NSModalResponseOK else {
            NSLog("Cancelled or aborted or stopped")
            return nil
        }

        return openPanel.url
    }

    private func appendAndReload(path: String) {

        CommandPreference().setApp(path: path)
        self.reloadData()
    }

    func add() {

        guard let url = self.letUserChooseApp() else { return }
        self.appendAndReload(path: url.path)
        self.selectLastRow()
    }

    private func removeApp(at row: Int) {

        let commandPreference = CommandPreference()
        let path = AppColumn.appPaths[row]
        commandPreference.removeApp(path: path)
    }

    private func confirmationAlert(for row: Int) -> NSAlert {

        let appName = AppColumn.appName(at: row)
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.informativeText = "Remove \(appName) ?"

        return alert
    }

    private func canRemove(row: Int) -> Bool {

        return row >= 2     // not remove Global and Finder.
    }

    func deleteSelected() {

        let row = self.selectedRow

        guard self.canRemove(row: row) else { return }

        guard let window = self.window else { return }

        self.confirmationAlert(for: row)
            .beginSheetModal(for: window,
                             completionHandler: {(modalResponse: NSModalResponse) -> Void in
            let OK: Int = 1000
            guard modalResponse == OK else { return }
            self.removeApp(at: row)

            self.reloadData()
        })
    }

    func buttonBarClicked(sender: Any?) {

        guard let segmentedControl = sender as? NSSegmentedControl else { return }

        switch segmentedControl.selectedSegment {
        case self.addSegment: self.add()
        case self.removeSegment: self.deleteSelected()
        default: break
        }
    }

    var buttonBarForMe: NSSegmentedControl {

        let buttonBar = self.buttonBar
        buttonBar.action = #selector(buttonBarClicked(sender:))

        return buttonBar
    }
}
