//
//  CanSelect.protocol.swift
//  fflow
//
//  Created by user on 2017/06/19.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

protocol CanSelect: NSTableViewDelegate, NSTableViewDataSource {

    func select(row: Int)
    func selectLastRow()
}

extension CanSelect where Self: NSTableView {

    private func validRow(row: Int) -> Int {

        guard row >= 0 else { return 0 }

        let maxRow = self.numberOfRows - 1

        guard row <= maxRow else { return maxRow }

        return row
    }

    func select(row: Int) {

        let validRow = self.validRow(row: row)

        let _ = self.tableView?(self, shouldSelectRow: validRow)
        
        let indexSet = IndexSet(integer: validRow)
        self.selectRowIndexes(indexSet, byExtendingSelection: false)
    }

    func selectLastRow() {

        self.select(row: self.numberOfRows - 1)
    }
}
