//
//  Preference.swift
//  fflow
//
//  Created by user on 2016/10/07.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa

class Preference {
    
    let userDefaults = NSUserDefaultsController().defaults
    private let KEY = "SerializedGestureCommandsManager"
    let gestureCommandsManager: GestureCommandsManager = GestureCommandsManager()
    
    init() {
        self.load()
    }
    
    private func load() {
        
        guard let serializedGestureCommandsManager = userDefaults.dictionary(forKey: KEY) else {
            return
        }
        
        for serializedGestureCommandsForApp in serializedGestureCommandsManager {
            let appName = serializedGestureCommandsForApp.key 
            let rawGestureCommandsForApp = serializedGestureCommandsForApp.value as! [String: String]
            
            let gestureCommandsForApp = GestureCommandsForApp(appName: appName)
            gestureCommandsForApp.append(rawGestureCommands: rawGestureCommandsForApp)
            self.gestureCommandsManager.append(gestureCommandsForApp: gestureCommandsForApp)
        }
    }
    
    func save() {
        let serialized = self.gestureCommandsManager.serialize()
        userDefaults.set(serialized, forKey: KEY)
    }
    
    func clear() {
        userDefaults.removeObject(forKey: KEY)
    }
}
