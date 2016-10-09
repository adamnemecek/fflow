//
//  AppNameManager.swift
//  fflow
//
//  Created by user on 2016/10/08.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

class TargetAppManager {
    
    private var gestureCommandManagers: [GestureCommandManager] = []
    
    init() {
    }
    
    private func getGestureCommandManager(appName: String) -> GestureCommandManager? {
        for gestureCommandManager in gestureCommandManagers {
            if gestureCommandManager.appName == appName { return gestureCommandManager}
        }
        return nil
    }
    
    func append(gestureCommandManager: GestureCommandManager) {
        self.gestureCommandManagers.append(gestureCommandManager)
    }
    
    func append(appName: String, gestureCommand: GestureCommand) {
        let gestureCommandManager = self.getGestureCommandManager(appName: appName)
        if gestureCommandManager == nil {
            let gestureCommandManager = GestureCommandManager(appName: appName)
            gestureCommandManager.append(gestureCommand: gestureCommand)
            self.append(gestureCommandManager: gestureCommandManager)
        }
    }
    
    func getKeystroke(appName: String, gesture: Gesture) -> Keystroke? {
        guard let gestureCommandManagerForApp = self.getGestureCommandManager(appName: appName) else {
            return nil
        }
        guard let gestureCommand = gestureCommandManagerForApp.getGestureCommand(gesture: gesture) else {
            return nil
        }
        return gestureCommand.keystroke
    }
}
