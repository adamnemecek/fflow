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

    static func which(x deltaX: CGFloat, y deltaY: CGFloat) -> Direction {

        let motionless: ClosedRange<CGFloat> = -1.0...1.0

        switch (deltaX, deltaY) {
        case (0.0, 0.0): return .No
        case (motionless, -50.0 ... -5.0): return .Up
        case (motionless, 5.0...50.0): return .Down
        case (-50.0 ... -3.0, motionless): return .Left
        case (3.0...50.0, motionless): return .Right
        default: return .Vague
        }
    }

    static func filter(string: String) -> String {

        return string.characters.map({ String($0) })
            .filter({ Direction(rawValue: $0) != nil }).joined()
    }

    var isNo: Bool {

        return self == .No
    }

    var isVague: Bool {

        return self == .Vague
    }
}

extension Direction {

    var unitVector: CGVector {

        switch self {
        case .Up:    return .init(dx:  0, dy:  1)
        case .Down:  return .init(dx:  0, dy: -1)
        case .Left:  return .init(dx: -1, dy:  0)
        case .Right: return .init(dx:  1, dy:  0)
        default:     return .zero
        }
    }

    var isVertical: Bool { return self.unitVector.dx == 0 }
    var isHorizontal: Bool { return self.unitVector.dy == 0 }
}

extension Direction {

    var string: String { return self.rawValue }

    var arrowString: String {

        switch self {
        case .Up: return Key.UpArrow.symbol
        case .Down: return Key.DownArrow.symbol
        case .Left: return Key.LeftArrow.symbol
        case .Right: return Key.RightArrow.symbol
        default: return "."
        }
    }
}
