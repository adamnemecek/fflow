//
//  ValidScroll.swift
//  fflow
//
//  Created by user on 2017/06/18.
//  Copyright © 2017年 user. All rights reserved.
//

import Foundation

struct ValidScroll {

    private static let    noXY: ClosedRange<CGFloat> =  0...0
    private static let vagueXY: ClosedRange<CGFloat> = -1...1

    private static let positiveX: ClosedRange<CGFloat> =   3 ... 50
    private static let negativeX: ClosedRange<CGFloat> = -50 ... -3
    private static let positiveY: ClosedRange<CGFloat> =   5 ... 50
    private static let negativeY: ClosedRange<CGFloat> = -50 ... -5

    private static func whichDirection(deltaX: CGFloat, deltaY: CGFloat) -> Direction? {

        switch (deltaX, deltaY) {
        case (noXY, noXY): return .No
        case (vagueXY, negativeY): return .Up
        case (vagueXY, positiveY): return .Down
        case (negativeX, vagueXY): return .Left
        case (positiveX, vagueXY): return .Right
        default: return nil
        }
    }

    let direction: Direction

    init?(deltaX: CGFloat, deltaY: CGFloat) {

        guard let direction = ValidScroll.whichDirection(deltaX: deltaX, deltaY: deltaY) else {

            return nil
        }

        self.direction = direction
    }
}
