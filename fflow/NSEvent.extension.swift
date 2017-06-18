//
//  NSEvent.extension.swift
//  fflow
//
//  Created by user on 2017/06/18.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

extension NSEvent {

    var naturalScrollingDeltaX: CGFloat {

        return (self.isDirectionInvertedFromDevice ? 1 : -1) * self.scrollingDeltaX
    }

    var naturalScrollingDeltaY: CGFloat {

        return (self.isDirectionInvertedFromDevice ? 1 : -1) * self.scrollingDeltaY
    }
}
