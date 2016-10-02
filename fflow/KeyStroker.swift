//
//  AppleScripter.swift
//  fflow
//
//  Created by user on 2016/10/02.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

class KeyStroker {
    
    var appName: String
    var source: String
    
    init(keyStroke: String) {
        self.keyCode = appName
    }
    
    func sendKeyStoke(keyStroke: String) {
        source = "tell application \"System Events\"\n"
            + "tell process \"\(appName)\"\n"
            + keyStroke + "\n"
            + "end tell\n"
            + "end tell\n"
    }
}
