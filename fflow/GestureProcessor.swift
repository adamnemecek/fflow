//
//  GestureManager.swift
//  fflow
//
//  Created by user on 2016/10/01.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


class GestureProcessor {
    
    private let gesture: Gesture = Gesture()
    
    init() {
    }
    
    func append(direction: Direction?) -> Gesture? {
        
        guard direction != nil else {
            
            if gesture.count <= 1 { // cancel
                gesture.clear()
                return nil
            }
            
            //fire
            let firingGesture = gesture.copy()
            gesture.clear()
            return firingGesture
        }
        
        guard !direction!.isVague() else { return nil }      // check vague
        guard !(direction == gesture.last) else { return nil }  // check duplicated
        
        gesture.append(direction: direction!)
        return nil
    }
}
