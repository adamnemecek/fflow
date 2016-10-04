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
    
    var keyStrokes = [String: [String: String]]()
    
    init() {
        if let keyStrokes = userDefaults.dictionary(forKey: "keyStrokes") {
            self.keyStrokes = keyStrokes as! [String: [String: String]]
        }
    }
    
    private func save() {
        userDefaults.set(keyStrokes, forKey: "keyStrokes")
        userDefaults.synchronize()
    }
    
    func reset() {
        keyStrokes.removeAll()
        save()
    }
    
    func setGesture(appName: String, gesture: String, keyCode: Int,
                    shift: Bool = false, option: Bool = false, command: Bool = false) {
        
        var modifierKeys = [String]()
        if shift { modifierKeys.append("shift down") }
        if option { modifierKeys.append("option down") }
        if command { modifierKeys.append("command down") }
        
        var keyStroke = "key code \(keyCode)"
        if modifierKeys.count > 0 {
            keyStroke += " using {\(modifierKeys.joined(separator: ","))}"
        }
        
        if keyStrokes[appName] == nil { keyStrokes[appName] = [:] }
        keyStrokes[appName]?[gesture] = keyStroke
        save()
    }
}
