//
//  KeyStroker.swift
//  fflow
//
//  Created by user on 2016/10/02.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation


struct KeyStroke {
    
    let keyCode: Int
    var modifierKeys: [String] = []
    
    init(keyCode: Int, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
        self.keyCode = keyCode
        if shift { modifierKeys.append("shift") }
        if control { modifierKeys.append("control") }
        if option { modifierKeys.append("option") }
        if command { modifierKeys.append("command") }
    }
}
