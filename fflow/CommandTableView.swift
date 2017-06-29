//
//  GestureTableView.swift
//  fflow
//
//  Created by user on 2017/01/01.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

class CommandTableView: NSTableView {

    static private var height: CGFloat { return CommandColumn.GesturePath.tableColumn.width }

    private var keptRow: Int = -1
    private var hasSelectedRow: Bool { return self.selectedRow != -1 }
    private var isClickedTwice: Bool { return self.clickedRow == self.keptRow }
    fileprivate func keepIndexOf(row: Int) { self.keptRow = row }

    fileprivate var currentAppPath: String = AppItem.Global.path

    func setCurrentApp(by notification: NSNotification) {

        guard let path = notification.object as? String else { return }
        self.currentAppPath = path

        self.reloadData()
    }

    init() {

        super.init(frame: .zero)

        self.rowHeight = CommandTableView.height
        self.headerView = nil
        self.focusRingType = .none
        self.intercellSpacing = NSSize(squaringOf: 5)

        self.gridColor = .knobColor
        self.gridStyleMask = [.solidVerticalGridLineMask]

        self.delegate = self
        self.dataSource = self

        self.addTableColumn(CommandColumn.GesturePath.tableColumn)
        self.addTableColumn(CommandColumn.GestureArrowString.tableColumn)
        self.addTableColumn(CommandColumn.Keystroke.tableColumn)

        self.action = #selector(self.clicked(sender:))

        NotificationCenter.default.addObserver(self, selector: #selector(self.setCurrentApp(by:)),
                                               name: .AppTableSelectionChanged,
                                               object: nil)
    }

    private var clickedKeystrokeListener: KeystrokeListener? {

        return self.view(atColumn: self.clickedColumn,
                                 row: self.clickedRow,
                                 makeIfNecessary: false) as? KeystrokeListener
    }

    func clicked(sender: Any) {

        guard self.hasSelectedRow else {

            self.reloadData()
            return
        }

        if self.isClickedTwice { self.clickedKeystrokeListener?.listen() }

        self.keepIndexOf(row: self.clickedRow)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
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

extension CommandTableView: CanSelect {}

extension CommandTableView: HasButtonBar {

    private var responseAdd: Int { return 1000 }
    private var responseCancel: Int { return 1001 }

    private var gesturePanelSide: CGFloat { return 210 }
    private var gesturePanelFrame: NSRect {

        return NSRect(size: NSSize(squaringOf: self.gesturePanelSide))
    }

    func add() {

        guard let window = self.window else { return }

        let alert = NSAlert()
        alert.messageText = "Attempt to scroll gesture."
        alert.informativeText = "( not yet. )"

        let okButton = alert.addButton(withTitle: "OK")
        okButton.isEnabled = false

        alert.addButton(withTitle: "Cancel")

        let gesturePanel = GesturePanel(frame: self.gesturePanelFrame)

        gesturePanel.afterRecognized = {(gesture: Gesture) -> Void in

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

        alert.accessoryView = gesturePanel

        alert.beginSheetModal(for: window, completionHandler: {(modalResponse) -> Void in

            switch modalResponse {
            case self.responseAdd:
                guard let gesture = gesturePanel.recognizedGesture else { return }
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
