//
//  NSEventModifierFlags.extension.swift
//  fflow
//
//  Created by user on 2017/08/16.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

extension NSEventModifierFlags {

    var cgEventFlags: CGEventFlags {

        return [
            self.contains(.control) ? .maskControl   : .maskNonCoalesced,
            self.contains(.option)  ? .maskAlternate : .maskNonCoalesced,
            self.contains(.shift)   ? .maskShift     : .maskNonCoalesced,
            self.contains(.command) ? .maskCommand   : .maskNonCoalesced
        ]
    }
}
