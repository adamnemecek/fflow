//
//  GestureCommandsManager.swift
//  fflow
//
//  Created by user on 2016/10/08.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

class GestureCommandsManager {
    
    private var gestureCommandsForApps: [GestureCommandsForApp] = []
    
    init() {
    }
    
    private func getGestureCommandsForApp(appName: String) -> GestureCommandsForApp? {
        for gestureCommandsForApp in gestureCommandsForApps {
            if gestureCommandsForApp.appName == appName { return gestureCommandsForApp}
        }
        return nil
    }
    
    func append(gestureCommandsForApp: GestureCommandsForApp) {
        self.gestureCommandsForApps.append(gestureCommandsForApp)
    }
    
    func append(appName: String, gestureCommand: GestureCommand) {
        var gestureCommandsForApp = self.getGestureCommandsForApp(appName: appName)
        if gestureCommandsForApp == nil {
            gestureCommandsForApp = GestureCommandsForApp(appName: appName)
        }
        gestureCommandsForApp?.append(gestureCommand: gestureCommand)
        self.append(gestureCommandsForApp: gestureCommandsForApp!)
    }
    
    func append(appName: String, gestureString: String, keystrokeString: String) -> Bool {
        guard let gestureCommand = GestureCommand(gestureString: gestureString, keystrokeString: keystrokeString) else {
            return false
        }
        self.append(appName: appName, gestureCommand: gestureCommand)
        return true
    }
    
    func getKeystroke(appName: String, gesture: Gesture) -> Keystroke? {
        guard let gestureCommandsForApp = self.getGestureCommandsForApp(appName: appName) else {
            return self.getKeystrokeForGlobal(gesture: gesture)
        }
        guard let gestureCommand = gestureCommandsForApp.getGestureCommand(gesture: gesture) else {
            return nil
        }
        return gestureCommand.keystroke
    }
    
    func getKeystroke(appName: String, gestureString: String) -> Keystroke? {
        let gesture = Gesture(fromString: gestureString)
        return self.getKeystroke(appName: appName, gesture: gesture)
    }
    
    func getKeystrokeForGlobal(gesture: Gesture) -> Keystroke? {
        guard let gestureCommandsForGlobal = self.getGestureCommandsForApp(appName: "Global") else {
            return nil
        }
        guard let gestureCommand = gestureCommandsForGlobal.getGestureCommand(gesture: gesture) else {
            return nil
        }
        return gestureCommand.keystroke
    }
    
    func serialize() -> [String: [String: String]] {
        
        var serialized: [String: [String: String]] = [:]
        for gestureCommandsforApp in self.gestureCommandsForApps{
            serialized[gestureCommandsforApp.appName] = gestureCommandsforApp.serialize()
        }
        return serialized
    }
}
