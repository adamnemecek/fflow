//
//  NNB.swift
//  fflow
//
//  Created by user on 2017/06/18.
//  Copyright © 2017年 user. All rights reserved.
//

import Cocoa

extension NSScreen {

    static func mousePointed() -> NSScreen? {

        let mouseLocation = NSEvent.mouseLocation()
        let screens = NSScreen.screens()

        guard let index = screens?.index(where: { $0.frame.contains(mouseLocation) }) else {

            return NSScreen.main()
        }

        return screens?[index]
    }
}


