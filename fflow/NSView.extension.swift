//
//  NSView.extension.swift
//  fflow
//
//  Created by user on 2016/12/17.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

extension NSView {

    convenience init(size: NSSize) {

        self.init(frame: .init(origin: .zero, size: size))
    }
}
