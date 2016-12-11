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
    case No = "n"

    static private var unitVectors: [String: (x: Int, y: Int)] {
        return [
            Direction.Up.rawValue: (0, 1),
            Direction.Down.rawValue: (0, -1),
            Direction.Left.rawValue: (-1, 0),
            Direction.Right.rawValue: (1, 0)
        ]
    }

    static func which(x: CGFloat, y: CGFloat) -> Direction {
        
        let motionless: ClosedRange<CGFloat> = -1.0...1.0
        
        switch (x, y) {
        case (0.0, 0.0): return .No
        case (motionless, -50.0 ... -5.0): return .Up
        case (motionless, 5.0...50.0): return .Down
        case (-50.0 ... -3.0, motionless): return .Left
        case (3.0...50.0, motionless): return .Right
        default: return .Vague
        }
    }
    
    static func filter(targetString: String?) -> String {
        guard targetString != nil else { return "" }
        
        return targetString!.characters.map({String($0)})
            .filter({(string: String) -> Bool in
                return Direction(rawValue: String(string)) != nil
            }).joined()
    }

    var isVague: Bool {

        return self == .Vague
    }

    var unitVector: (x: Int, y: Int) {

        guard let unitVector = Direction.unitVectors[self.rawValue] else {
            return (0, 0)
        }

        return unitVector
    }
}
