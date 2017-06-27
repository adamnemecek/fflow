//
//  Gesture.swift
//  fflow
//
//  Created by user on 2016/10/06.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class Gesture {

    fileprivate var directions: [Direction] = []

    init() {
    }

    init(string gestureString: String) {

        self.directions = Direction.array(from: gestureString)
    }
}

protocol CanGiveGestureString {

    var string: String { get }
    var arrowString: String { get }
}

extension CanGiveGestureString where Self: Gesture {

    var string: String {

        return self.directions.map({$0.string}).joined()
    }

    var arrowString: String {

        return self.directions.map({$0.arrowString}).joined()
    }
}

protocol CanAppendAndRelease: CanGiveGestureString {

    func appendAndReleaseIfCan(direction: Direction) -> Gesture?
}

extension CanAppendAndRelease where Self: Gesture {

    private var last: Direction? { return self.directions.last }

    private var count: Int { return self.directions.count }
    private var isCompleted: Bool { return self.last == .No }
    private var isCanceled: Bool { return self.count <= 2 && self.isCompleted }
    private var isEmpty: Bool { return self.directions.isEmpty }

    private func isAvailable(direction: Direction) -> Bool {

        return !direction.isVague
    }

    private func isAvailableIfWouldBe(first direction: Direction) -> Bool {

        return !self.isEmpty || !direction.isNo
    }

    private func isAvailableToBe(last direction: Direction) -> Bool {

        return direction != self.last
    }

    private func clear() {

        directions.removeAll()
    }

    private func append(direction: Direction) {

        guard isAvailable(direction: direction) else { return }
        guard isAvailableIfWouldBe(first: direction) else { return }
        guard isAvailableToBe(last: direction) else { return }

        self.directions.append(direction)

        if self.isCanceled { self.clear() }
    }

    private var completedPartString: String? {

        guard self.isCompleted else { return nil }

        let stringAll = self.string

        guard let nCharacter = Direction.No.rawValue.characters.first else { return nil }
        guard let nIndex = self.string.characters.index(of: nCharacter) else { return nil }

        return stringAll.substring(to: nIndex)
    }

    private func releaseIfCan() -> Gesture? {

        guard let gestureString = self.completedPartString else { return nil }

        let gesture = Gesture(string: gestureString)

        self.clear()

        return gesture
    }

    func appendAndReleaseIfCan(direction: Direction) -> Gesture? {

        self.append(direction: direction)

        return self.releaseIfCan()
    }
}

extension Gesture: CanAppendAndRelease {}

protocol CanGivePath {

    var path: NSBezierPath { get }
}

extension CanGivePath where Self: Gesture {

    static private var initialPathLength: CGFloat { return 100 }

    static private var rivetSide: CGFloat { return 7 }
    static private var rivetSize: NSSize { return NSSize(squaringOf: self.rivetSide) }

    static private var radius: CGFloat { return self.initialPathLength * 0.3 }

    static private func startAngle(prev: Direction, current: Direction) -> CGFloat {

        if prev.isVertical { return current == .Left ? 0 : 180 }
        if current == .Up { return 270 }

        return 90
    }

    static private func endAngle(prev: Direction, current: Direction) -> CGFloat {

        if prev == .Up { return 90 }
        if prev == .Down { return 270 }
        if prev == .Left { return 180 }
        return 0
    }

    static private func isClockwise(prev: Direction, current: Direction) -> Bool {

        switch (prev, current) {
        case (.Right, .Up): fallthrough
        case (.Up, .Left): fallthrough
        case (.Left, .Down): fallthrough
        case (.Down, .Right): fallthrough
        case (.Left, .Right): fallthrough
        case (.Down, .Up): return false
        default:
            return true
        }
    }

    static private func rivet(at center: NSPoint) -> NSBezierPath {

        let rect = NSRect(center: center, size: self.rivetSize)
        let rivet = NSBezierPath(ovalIn: rect)
        rivet.move(to: center)

        return rivet
    }

    static private func joint(at startPoint: NSPoint, prev: Direction, current: Direction) -> NSBezierPath {

        let arc = NSBezierPath(initialPoint: startPoint)

        guard prev != .No else { return arc }

        let startAngle = self.startAngle(prev: prev, current: current)
        let endAngle = Self.endAngle(prev: prev, current: current)

        Self.isClockwise(prev: prev, current: current)
            ? arc.clockwise(radius: self.radius, startAngle: startAngle, endAngle: endAngle)
            : arc.counterClockwise(radius: self.radius, startAngle: startAngle, endAngle: endAngle)

        return arc
    }

    var path: NSBezierPath {

        let path = NSBezierPath(initialPoint: .zero)
        path.lineCapStyle = .roundLineCapStyle

        var length = Self.initialPathLength
        var prev: Direction = .No

        for current in self.directions {

            let joint = Self.joint(at: path.currentPoint, prev: prev, current: current)
            path.append(joint)

            let rivet = Self.rivet(at: path.currentPoint)
            path.append(rivet)

            path.relativeLine(to: (length * current.unitVector).endPoint)

            prev = current
            length *= 0.9
        }

        return path
    }
}

extension Gesture: CanGivePath {}

// extension for straight path

//extension Gesture {
//
//    fileprivate var initialLength: CGFloat { return 100 }
//
//    private var radian: CGFloat { return CGFloat(M_PI) / 18 }
//    private var clockwise: CGAffineTransform { return .init(rotationAngle: -self.radian) }
//    private var counterClockwise: CGAffineTransform { return .init(rotationAngle: self.radian) }
//    private var notRotate: CGAffineTransform { return .init(rotationAngle: 0) }
//
//    private var rivetSide: CGFloat { return 7 }
//    private var rivetSize: NSSize { return NSSize(squaringOf: self.rivetSide) }
//
//    fileprivate func rivet(at center: NSPoint) -> NSBezierPath {
//
//        let rect = NSRect(center: center, size: self.rivetSize)
//        let rivet = NSBezierPath(ovalIn: rect)
//        rivet.move(to: center)
//
//        return rivet
//    }
//
//    private func oneLine(vector: CGVector) -> NSBezierPath {
//
//        let line = NSBezierPath(initialPoint: .zero)
//
//        let rivet = self.rivet(at: .zero)
//        line.append(rivet)
//
//        line.relativeLine(to: vector.endPoint)
//
//        return line
//    }
//
//    private func rotation(prev: CGVector, current: CGVector) -> CGAffineTransform {
//
//        let sub = prev - current
//        guard sub.dx != 2 && sub.dy != 2 else { return self.counterClockwise }
//        guard sub.dx != -2 && sub.dy != -2 else { return self.clockwise }
//
//        return self.notRotate
//    }
//
//    private func rotated(prev: CGVector, current: CGVector) -> CGVector {
//
//        let rotation = self.rotation(prev: prev, current: current)
//        let rotatedPoint = current.endPoint.applying(rotation)
//
//        return CGVector(endPoint: rotatedPoint)
//    }
//
//    var path: NSBezierPath {
//
//        let path = NSBezierPath(initialPoint: .zero)
//        path.lineCapStyle = .roundLineCapStyle
//
//        var length = self.initialLength
//        var prev: CGVector = .zero
//
//        for direction in self.directions {
//
//            let rotated = self.rotated(prev: prev, current: direction.unitVector)
//
//            let oneLine = self.oneLine(vector: length * rotated)
//
//            let point = path.currentPoint
//            oneLine.transform(using: .init(translationByX: point.x, byY: point.y))
//
//            path.append(oneLine)
//
//            prev = rotated
//            length *= 0.9
//        }
//
//        return path
//    }
//}
