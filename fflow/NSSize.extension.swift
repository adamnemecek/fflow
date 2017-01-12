//
//  NSSize.extension.swift
//  fflow
//
//  Created by user on 2016/12/22.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation

extension NSSize {

    var shortSide: CGFloat {

        let width = self.width
        let height = self.height
        return width < height ? width : height
    }

    var longSide: CGFloat {

        let width = self.width
        let height = self.height
        return width > height ? width : height
    }
}

extension NSSize {

    init(squaringOf side: CGFloat) {

        self.init(width: side, height: side)
    }
}

extension NSSize {

    func insetBy(dx: CGFloat, dy: CGFloat) -> NSSize {

        return NSSize(width: self.width - 2 * dx,
                      height: self.height - 2 * dy)
    }
}
