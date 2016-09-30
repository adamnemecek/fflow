//
//  Direction.swift
//  fflow
//
//  Created by user on 2016/09/30.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

enum Direction: String {
    
    case Up = "u"
    case Down = "d"
    case Left = "l"
    case Right = "r"
    case Vague = "v"
    
    static func which(_ x: CGFloat, y: CGFloat) -> Direction? {
        
        let motionless: ClosedRange<CGFloat> = -1.0...1.0
        
        switch (x, y) {
        case (0.0, 0.0): return nil
        case (motionless, -50.0 ... -5.0): return .Up
        case (motionless, 5.0...50.0): return .Down
        case (-50.0 ... -3.0, motionless): return .Left
        case (3.0...50.0, motionless): return .Right
        default: return .Vague
        }
    }
    
}
