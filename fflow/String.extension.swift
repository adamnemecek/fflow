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

    func trimmingLeading(character: Character) -> String {

        var trimmed: String = ""

        for (i, _character) in self.characters.enumerated() {

            guard _character != character else { continue }
            trimmed = String(self.characters.dropFirst(i))
            break
        }

        return trimmed
    }
}
