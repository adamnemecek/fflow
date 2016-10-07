//
//  Gesture.swift
//  fflow
//
//  Created by user on 2016/10/06.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

class Gesture {
    
    private var gesture: [Direction] = []
    
    var count: Int { return gesture.count }
    var last: Direction? { return gesture.last }
    
    init() {
    }
    
    init(fromString: String?) {
        guard fromString != nil else { return }
        
        let filterd = Direction.filter(targetString: fromString)
        self.gesture = filterd.characters.map({(character: Character) -> Direction in
            Direction(rawValue: String(character))!
        })
    }
    
    func append(direction: Direction) {
        self.gesture.append(direction)
    }
    
    func clear() {
        gesture.removeAll()
    }
    
    func toString() -> String? {
        return gesture.map({$0.rawValue}).joined()
    }
    
    func copy() -> Gesture {
        return Gesture(fromString: self.toString())
    }
}
