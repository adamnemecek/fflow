//
//  String.extension.swift
//  fflow
//
//  Created by user on 2016/12/11.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

extension String {

    func firstIs(it: String) -> Bool {

        guard let first = self.characters.first else { return false }
        return String(first) == it
    }
}
