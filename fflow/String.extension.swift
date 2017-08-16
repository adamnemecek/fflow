//
//  String.extension.swift
//  fflow
//
//  Created by user on 2016/12/11.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

extension String {

    func firstIs(it this: String) -> Bool {

        guard let first = self.characters.first else { return false }
        return String(first) == this
    }

    func trimmingLeading(oneLetter: String) -> String {

        guard let first = oneLetter.characters.first else { return self }
        return self.trimmingLeading(character: first)
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

    func removingOccurrence(of this: String) -> String {

        return self.replacingOccurrences(of: this, with: "")
    }
}
