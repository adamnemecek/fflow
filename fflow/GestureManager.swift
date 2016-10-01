//
//  GestureManager.swift
//  fflow
//
//  Created by user on 2016/10/01.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


class GestureManager {
    
    private var queue = ""
    
    init() {
    }
    
    private func shouldFire(direction: String?) -> Bool {
        return direction == nil && queue.characters.count >= 2
    }
    private func shouldCancel(direction: String?) -> Bool {
        return direction == nil && queue.characters.count <= 1
    }
    
    private func isDuplicated(direction: String?) -> Bool {
        guard let d = direction else { return false }
        return d.characters.first == queue.characters.last
    }
    private func isVague(direction: String?) -> Bool {
        return direction == "v"
    }
    
    private func appendQueue(direction: String?) {
        queue += direction!
    }
    private func clearQueue() {
        queue = ""
    }
    
    func add(direction: String?) -> String? {
        
        guard !isVague(direction: direction) else {
            return nil
        }
        
        guard !isDuplicated(direction: direction) else {
            return nil
        }
        
        guard !shouldCancel(direction: direction) else {
            clearQueue()
            return nil
        }
        
        guard shouldFire(direction: direction) else {
            appendQueue(direction: direction)
            return nil
        }
        
        let firing = queue
        clearQueue()
        return firing
    }
}
