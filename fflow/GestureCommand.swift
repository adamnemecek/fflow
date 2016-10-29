//
//  GestureCommand.swift
//  fflow
//
//  Created by user on 2016/10/06.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

class GestureCommand {
    
    let gesture: Gesture
    let keystroke: Keystroke
    
    var gestureString: String {
        return gesture.toString()
    }
    var keystrokeString: String {
        return keystroke.toString()
    }
    
    init(gesture: Gesture, keystroke: Keystroke) {
        self.gesture = gesture
        self.keystroke = keystroke
    }
    
    init?(gestureString: String, keystrokeString: String) {
        guard let keystroke = Keystroke(fromString: keystrokeString) else { return nil }
        self.keystroke = keystroke
        self.gesture = Gesture(fromString: gestureString)
    }
}
