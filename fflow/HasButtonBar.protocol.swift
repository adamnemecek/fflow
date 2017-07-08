//
//  HasButtonBar.protocol.swift
//  fflow
//
//  Created by user on 2017/06/19.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

protocol HasButtonBar {

    var addSegment: Int { get }
    var removeSegment: Int { get }
    var buttonBar: NSSegmentedControl { get }
}

extension HasButtonBar {

    private var addImageTemplate: NSImage? { return NSImage(named: NSImageNameAddTemplate) }
    private var removeImageTemplate: NSImage? { return NSImage(named: NSImageNameRemoveTemplate) }

    var addSegment: Int { return 0 }
    var removeSegment: Int { return 1 }

    var buttonBar: NSSegmentedControl {

        let segmentedControl = NSSegmentedControl(frame: NSRect(width: 60, height: 30))

        segmentedControl.trackingMode = .momentary
        segmentedControl.segmentCount = 2

        segmentedControl.setImage(self.addImageTemplate, forSegment: self.addSegment)
        segmentedControl.setImage(self.removeImageTemplate, forSegment: self.removeSegment)

        segmentedControl.target = self as AnyObject?

        return segmentedControl
    }
}
