//
//  GestureCommandsForApp.swift
//  fflow
//
//  Created by user on 2016/09/30.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa

class GestureCommandsForApp {
    
    let appName: String
    private var gestureCommands: [GestureCommand] = []
    
    init(appName: String) {
        self.appName = appName
    }
    
    func append(gestureCommand: GestureCommand) {
        self.gestureCommands.append(gestureCommand)
    }
    
    func append(gestureCommands: [GestureCommand]) {
        self.gestureCommands.append(contentsOf: gestureCommands)
    }
    
    func append(rawGestureCommands: [String: String]) {
        var gestureCommands: [GestureCommand] = []
        for rawGestureCommand in rawGestureCommands {
            guard let keystroke = Keystroke(fromString: rawGestureCommand.value) else { continue }
            let gesture = Gesture(fromString: rawGestureCommand.key)
            let gestureCommand = GestureCommand(gesture: gesture, keystroke: keystroke)
            gestureCommands.append(gestureCommand)
        }
        self.append(gestureCommands: gestureCommands)
    }
    
    func append(gesture: Gesture, keystroke: Keystroke) {
        gestureCommands.append(GestureCommand(gesture: gesture, keystroke: keystroke))
    }
    
    func append(gestureString: String, keystrokeString: String) -> Bool {
        guard let keystroke = Keystroke(fromString: keystrokeString) else { return false }
        let gesture: Gesture = Gesture(fromString: gestureString)
        gestureCommands.append(GestureCommand(gesture: gesture, keystroke: keystroke))
        return true
    }
    
    func getGestureCommand(gestureString: String) -> GestureCommand? {
        
        for gestureCommand in gestureCommands {
            if gestureCommand.gestureString == gestureString { return gestureCommand }
        }
        return nil
    }
    
    func getGestureCommand(gesture: Gesture) -> GestureCommand? {
        
        let gestureString: String = gesture.toString()
        return self.getGestureCommand(gestureString: gestureString)
    }
    
    func serialize() -> [String: String] {
        var serialized: [String: String] = [:]
        for gestureCommand in gestureCommands {
            serialized[gestureCommand.gestureString] = gestureCommand.keystrokeString
        }
        return serialized
    }
    
    func reset() {
        gestureCommands.removeAll()
    }
}
