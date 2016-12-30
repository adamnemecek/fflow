//
//  Gesture.swift
//  fflow
//
//  Created by user on 2016/10/06.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class Gesture {


    // MARK: Private static property
    // MARK: Private static method
    // MARK: Static property
    // MARK: Static method


    // MARK: Private instance property

    fileprivate var directions: [Direction] = []
    
    private var last: Direction? { return self.directions.last }
    private var count: Int { return self.directions.count }
    private var isEmpty: Bool { return self.directions.isEmpty }
    private var isCompleted: Bool { return self.last == .No }
    private var isCanceled: Bool { return self.count <= 1 && self.isCompleted }

    private var stringOfCompletedPart: String? {

        guard self.isCompleted else { return nil }

        let stringAll = self.string

        guard let nCharacter = Direction.No.rawValue.characters.first else { return nil }
        guard let nIndex = self.string.characters.index(of: nCharacter) else { return nil }

        return stringAll.substring(to: nIndex)
    }


    // MARK: Instance property

    var string: String {

        return self.directions.map({$0.rawValue}).joined()
    }

    
    // MARK: Designated init
    
    init() {
    }

    init(fromString gestureString: String) {

        let filteredString = Direction.filter(string: gestureString)
        let validString = filteredString.trimmingLeading(character: "n")

        self.directions = validString.characters.map({ Direction(rawValue: String($0))! })
    }

    
    // MARK: Convenience init
    // MARK: Private instance method
    
    private func clear() {

        directions.removeAll()
    }

    
    // MARK: Instance method
    
    func append(direction: Direction) {

        guard !direction.isVague else { return }
        guard !self.isEmpty || !direction.isNo else { return } // .No must not be first
        guard direction != self.last else { return } // whether duplicated or not

        self.directions.append(direction)
        
        if self.isCanceled { self.clear() }
    }

    func append(x: CGFloat, y: CGFloat) {

        let direction = Direction.which(x: x, y: y)
        self.append(direction: direction)
    }

    func release() -> String? {

        guard let partString = self.stringOfCompletedPart else { return nil }

        self.clear()

        return partString
    }
}





extension Gesture {

    private var radian: CGFloat { return CGFloat(M_PI) / 18 }
    private var clockwise: CGAffineTransform { return .init(rotationAngle: -self.radian) }
    private var counterClockwise: CGAffineTransform { return .init(rotationAngle: self.radian) }
    private var notRotate: CGAffineTransform { return .init(rotationAngle: 0) }

    private var rivetSide: CGFloat { return 7 }
    private var rivetSize: NSSize { return NSSize(squaringOf: self.rivetSide) }

    fileprivate func rivet(at center: NSPoint) -> NSBezierPath {

        let rect = NSRect(center: center, size: self.rivetSize)
        let rivet = NSBezierPath(ovalIn: rect)
        rivet.move(to: center)

        return rivet
    }

    private func oneLine(vector: CGVector) -> NSBezierPath {

        let line = NSBezierPath(initialPoint: .zero)

        let rivet = self.rivet(at: .zero)
        line.append(rivet)

        line.relativeLine(to: vector.endPoint)

        return line
    }

    private func rotation(prev: CGVector, current: CGVector) -> CGAffineTransform {

        let sub = prev - current
        guard sub.dx != 2 && sub.dy != 2 else { return self.counterClockwise }
        guard sub.dx != -2 && sub.dy != -2 else { return self.clockwise }

        return self.notRotate
    }

    private func rotated(prev: CGVector, current: CGVector) -> CGVector {

        let rotation = self.rotation(prev: prev, current: current)
        let rotatedPoint = current.endPoint.applying(rotation)

        return CGVector(endPoint: rotatedPoint)
    }

    var path: NSBezierPath {

        let path = NSBezierPath(initialPoint: .zero)
        path.lineCapStyle = .roundLineCapStyle

        var length: CGFloat = 100
        var prev: CGVector = .zero

        for direction in self.directions {

            let rotated = self.rotated(prev: prev, current: direction.unitVector)

            let oneLine = self.oneLine(vector: length * rotated)

            let point = path.currentPoint
            oneLine.transform(using: .init(translationByX: point.x, byY: point.y))

            path.append(oneLine)

            prev = rotated
            length *= 0.9
        }

        return path
    }
}
