//
//  NSPoint.extension.swift
//  fflow
//
//  Created by user on 2016/12/23.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

extension NSPoint {

    init(bothXY x: CGFloat) {

        self.init(x: x, y: x)
    }
}
