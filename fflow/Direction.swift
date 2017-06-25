//
//  Direction.swift
//  fflow
//
//  Created by user on 2016/09/30.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

enum Direction: String {

    case Up = "U"
    case Down = "D"
    case Left = "L"
    case Right = "R"
    case Vague = "V"
    case No = "N"

    var isVague: Bool {

        return self == .Vague
    }

    var isNo: Bool {

        return self == .No
    }
}

protocol CanGiveDirectionString {

    var string: String { get }
    var arrowString: String { get }
}

extension Direction: CanGiveDirectionString {

    var string: String {

        return self.rawValue
    }

    var arrowString: String {

        switch self {
        case .Up:    return "↑"
        case .Down:  return "↓"
        case .Left:  return "←"
        case .Right: return "→"
        default:     return "."
        }
    }
}

private protocol Vectorable {

    var unitVector: CGVector { get }
    var isVertical: Bool { get }
    var isHorizontal: Bool { get }
}

extension Direction: Vectorable {

    var unitVector: CGVector {

        switch self {
        case .Up:    return .init(dx:  0, dy:  1)
        case .Down:  return .init(dx:  0, dy: -1)
        case .Left:  return .init(dx: -1, dy:  0)
        case .Right: return .init(dx:  1, dy:  0)
        default:     return .zero
        }
    }

    var isVertical: Bool {

        return self.unitVector.dx == 0
    }

    var isHorizontal: Bool {

        return self.unitVector.dy == 0
    }
}

private protocol CanInitFromString {

    static func array(from: String) -> [Direction]
}

extension Direction: CanInitFromString {

    private static func filter(string: String) -> String {

        return string.characters.map({ String($0).uppercased() })
            .filter({ Direction(rawValue: $0) != nil }).joined()
    }

    static func array(from directionsString: String) -> [Direction] {

        let filteredString = Direction.filter(string: directionsString)
        let validString = filteredString.trimmingLeading(oneLetter: Direction.No.string)

        return validString.characters.map({ Direction(rawValue: String($0))! })
    }
}
