//
//  ExtensionNSBezierPath.swift
//  fflow
//
//  Created by user on 2016/10/20.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa


extension NSBezierPath {
    
    func left(dx: CGFloat) {
        self.relativeLine(to: NSMakePoint(-1 * dx, 0))
    }
    
    func right(dx: CGFloat) {
        self.relativeLine(to: NSMakePoint(dx, 0))
    }
    
    func up(dy: CGFloat) {
        self.relativeLine(to: NSMakePoint(0, dy))
    }
    
    func down(dy: CGFloat) {
        self.relativeLine(to: NSMakePoint(0, -1 * dy))
    }
}
