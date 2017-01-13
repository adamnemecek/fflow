//
//  HasButtonBar.swift
//  fflow
//
//  Created by user on 2017/01/01.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa








protocol HasButtonBar {

    var addSegment: Int { get }
    var removeSegment: Int { get }

    var buttonBar: NSSegmentedControl { get }
}

extension HasButtonBar {

    var addSegment: Int { return 0 }
    var removeSegment: Int { return 1 }

    var buttonBar: NSSegmentedControl {

        let segmentedControl = NSSegmentedControl(frame: .init(width: 60, height: 30))

        segmentedControl.trackingMode = .momentary
        segmentedControl.segmentCount = 2
        
        segmentedControl.setImage(NSImage(named: NSImageNameAddTemplate), forSegment: 0)
        segmentedControl.setImage(NSImage(named: NSImageNameRemoveTemplate), forSegment: 1)

        segmentedControl.target = self as AnyObject?

        return segmentedControl
    }
}


