//
//  Setting.swift
//  fflow
//
//  Created by user on 2016/09/30.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa

class Setting {
    
    let userDefaults = NSUserDefaultsController().defaults
    
    var gestures = [String: [String: String]]()
    
    init() {
        if let gesturesSetting = userDefaults.dictionary(forKey: "gestures") {
            gestures = gesturesSetting as! [String: [String: String]]
        }
    }
    
    private func save() {
        userDefaults.set(gestures, forKey: "gestures")
    }
    
    func setGesture(appName: String, gesture: String, keyCode: Int,
                    shift: Bool = false, option: Bool = false, command: Bool = false) {
        var modifierKeys = [String]()
        if shift { modifierKeys.append("shift down") }
        if option { modifierKeys.append("option down") }
        if command { modifierKeys.append("command down") }
        
        var statement = "key code \(keyCode)"
        if modifierKeys.count > 1 {
            statement += " using {\(modifierKeys.joined(separator: ","))}"
        }
        
        gestures[appName] = [gesture: statement]
        save()
    }
}
