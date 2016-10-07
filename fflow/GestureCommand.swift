//
//  KeystrokeGestureSet.swift
//  fflow
//
//  Created by user on 2016/10/06.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

struct GestureCommand {
    
    let gesture: Gesture
    let keystroke: Keystroke
    
    var gestureString: String? {
        return gesture.toString()
    }
}
