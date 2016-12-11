//
//  Gesture.swift
//  fflow
//
//  Created by user on 2016/10/06.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

class Gesture {


    // MARK: Private static property
    // MARK: Private static method
    // MARK: Static property
    // MARK: Static method


    // MARK: Private instance property

    private var directions: [Direction] = []
    
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
        guard !self.isEmpty || !direction.isNo else { return } // .No must no be first
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
