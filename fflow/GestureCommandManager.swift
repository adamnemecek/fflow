//
//  Setting.swift
//  fflow
//
//  Created by user on 2016/09/30.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa

class GestureCommandManager {
    
    private var gestureCommands: [String: [GestureCommand]] = [:]
    
    init() {
    }
    
    func reset() {
        gestureCommands.removeAll()
    }
    
    func append(appName: String, gestureCommand: GestureCommand) {
        if self.gestureCommands[appName] == nil {
            self.gestureCommands[appName] = []
        }
        self.gestureCommands[appName]!.append(gestureCommand)
    }
    
    func append(appName: String, gestureCommands: [GestureCommand]) {
        self.gestureCommands[appName]?.append(contentsOf: gestureCommands)
    }
    
    func getKeystroke(appName: String, gesture: Gesture) -> Keystroke? {
        let gestureCommandsForApp = gestureCommands[appName]
        let gestureCommand = gestureCommandsForApp?.filter({$0.gestureString == gesture.toString()})
        return gestureCommand?[0].keystroke
    }
}
