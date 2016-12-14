//
//  Preference.swift
//  fflow
//
//  Created by user on 2016/10/07.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa

class Preference {

    // MARK: Private static property
    // MARK: Private static method
    // MARK: Static property
    // MARK: Static method
    // MARK: Private instance property

    private let userDefaults = NSUserDefaultsController().defaults


    // MARK: Instance property

    var itemsAtDomain: [String: Any] {

        guard let domainName = Bundle.main.bundleIdentifier else { return [:] }
        guard let items = self.userDefaults.persistentDomain(forName: domainName) else { return [:] }

        return items
    }


    // MARK: Designated init
    
    init() {
    }


    // MARK: Convenience init
    // MARK: Private instance method

    
    // MARK: Instance method
    
    func clearCompletely() {

        let keys = self.itemsAtDomain.keys
        keys.forEach({ userDefaults.removeObject(forKey: $0) })
    }
}
