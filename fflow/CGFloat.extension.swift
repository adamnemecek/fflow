//
//  CGFloat.extension.swift
//  fflow
//
//  Created by user on 2016/12/29.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

infix operator **: BitwiseShiftPrecedence

extension CGFloat {

    static func **(cardinal: CGFloat, index: Int) -> CGFloat {

        var pow: CGFloat = 1

        for _ in 0..<index { pow *= cardinal }

        return pow
    }
}
