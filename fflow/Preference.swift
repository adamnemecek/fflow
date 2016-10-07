//
//  Preference.swift
//  fflow
//
//  Created by user on 2016/10/07.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

//class Preference {
//    
//    let userDefaults = NSUserDefaultsController().defaults
//    private let KEY_FOR_KEYSTROKES = "keystrokes"
//    
//    init() {
//    }
//}


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
