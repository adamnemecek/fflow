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
}


//[
//    "gesture": "dr",
//    "keyCode": "123",
//    "shift": "true",
//    "control": "true",
//    "option": "true",
//    "command": "true"
//]

//    private func load() -> [String: GestureSet] {
//        guard let _gestureSets = userDefaults.dictionary(forKey: KEY_FOR_KEYSTROKES) else {
//            return [:]
//        }
//        let gestureSets = (_gestureSets as [String: Any]).map({ (appName: String, _gestures: Any) -> [String: GestureSet] in
//            let gestures = _gestures as! [String: Keystroke]
//            return [appName: GestureSet(gestureSet: gestures)]
//        })
//        return gestureSets
//        
//    }
//    private func save() {
//        let keystrokes = keystrokes.map({() -> })
//        userDefaults.set(keystrokes, forKey: KEY_FOR_KEYSTROKES)
//        userDefaults.synchronize()
//    }
