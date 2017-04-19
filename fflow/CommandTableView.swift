//
//  GestureTableView.swift
//  fflow
//
//  Created by user on 2017/01/01.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

class CommandTableView: NSTableView {

    fileprivate var currentAppPath: String = AppItem.Global.path

    init() {

        super.init(frame: .zero)

        self.rowHeight = 30
        self.headerView = nil
        self.focusRingType = .none
        self.intercellSpacing = NSSize(squaringOf: 5)

        self.gridColor = .knobColor
        self.gridStyleMask = [.solidVerticalGridLineMask]

        self.delegate = self
        self.dataSource = self

        self.addTableColumn(CommandColumn.Gesture.tableColumn)
        self.addTableColumn(CommandColumn.Keystroke.tableColumn)

        self.doubleAction = #selector(self.doubleClicked(sender:))

        NotificationCenter.default.addObserver(self, selector: #selector(self.change(notification:)),
                                               name: .AppTableSelectionChenged,
                                               object: nil)
    }

    func doubleClicked(sender: Any) {

        guard let commandTableView = sender as? CommandTableView else { return }

        let view = commandTableView.view(atColumn: commandTableView.clickedColumn,
                                         row: commandTableView.clickedRow,
                                         makeIfNecessary: false)

        guard let keystrokeListener = view as? KeystrokeListener else { return }

        keystrokeListener.listen()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func change(currentApp path: String) {

        self.currentAppPath = path
        self.reloadData()
    }

    func change(notification: NSNotification) {

        guard let path = notification.object as? String else { return }
        self.change(currentApp: path)
    }

    deinit {

        NotificationCenter.default.removeObserver(self)
    }
}

extension CommandTableView: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let identifier = tableColumn?.identifier else { return nil }

        guard let commandColumn = CommandColumn(rawValue: identifier) else { return nil }

        return commandColumn.view(forApp: self.currentAppPath, at: row)
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {

        self.reloadData()
        return true
    }
}

extension CommandTableView: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {

        return CommandColumn.rowCount(forApp: self.currentAppPath)
    }
}

extension CommandTableView: Selectable {}

extension CommandTableView: HasButtonBar {

    private var responseAdd: Int { return 1000 }
    private var responseCancel: Int { return 1001 }

    func add() {

        guard let window = self.window else { return }

        let alert = NSAlert()
        alert.messageText = "Attempt to scroll gesture."
        alert.informativeText = "( not yet. )"

        let okButton = alert.addButton(withTitle: "OK")
        okButton.isEnabled = false

        alert.addButton(withTitle: "Cancel")

        let scrollGestureRecognizer = ScrollGestrueRecognizer(size: NSSize.init(squaringOf: 200))

        scrollGestureRecognizer.afterRecognized = {(gesture: Gesture) -> Void in

            alert.informativeText = gesture.arrowString
            let gestures = CommandPreference().gestures(forApp: self.currentAppPath)
            guard !gestures.contains(gesture.string) else {
                alert.informativeText += " is duplicated !!"
                okButton.isEnabled = false
                return
            }

            okButton.isEnabled = true
            return
        }

        alert.accessoryView = scrollGestureRecognizer

        alert.beginSheetModal(for: window, completionHandler: {(modalResponse) -> Void in

            switch modalResponse {
            case self.responseAdd:
                guard let gesture = scrollGestureRecognizer.recognizedGesture else { return }
                CommandPreference().setGesture(forApp: self.currentAppPath, gestureString: gesture.string)
                self.reloadData()
                self.selectLastRow()
            case self.responseCancel:
                fallthrough
            default:
                break
            }
        })
    }

    func deleteSelected() {

        let row = self.selectedRow

        guard row >= 0 else { return }

        let path = self.currentAppPath
        let gestureString = CommandColumn.gestureString(forApp: path, at: row)
        CommandPreference().removeGesture(forApp: path, gestureString: gestureString)

        self.reloadData()

        self.select(row: row)
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
