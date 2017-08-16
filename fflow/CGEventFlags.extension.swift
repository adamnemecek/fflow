//
//  CGEventFlags.extension.swift
//  fflow
//
//  Created by user on 2017/08/16.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

extension CGEventFlags {

    func keys() -> [Key] {

        var keys: [Key] = []
        if self.contains(.maskControl) { keys.append(Key.Control) }
        if self.contains(.maskAlternate) { keys.append(Key.Option) }
        if self.contains(.maskShift) { keys.append(Key.Shift) }
        if self.contains(.maskCommand) { keys.append(Key.Command) }

        return keys
    }
}
