//
//  GestureCommandsManager.swift
//  fflow
//
//  Created by user on 2016/10/08.
//  Copyright © 2016年 user. All rights reserved.
//

import Foundation
import Cocoa

class CommandPreference {


    // MARK: Private static property
    // MARK: Private static method
    // MARK: Static property
    // MARK: Static method


    // MARK: Private instance property

    private let userDefaults = NSUserDefaultsController().defaults

    private let appPathsKey = "appPaths"


    // MARK: Instance property

    var appPaths: [String] {
        
        guard let anyAppPaths = self.userDefaults.array(forKey: self.appPathsKey) else { return [] }
        guard let appPaths = anyAppPaths as? [String] else { return [] }
        return appPaths
    }


    // MARK: Designated init
    // MARK: Convenience init

    
    // MARK: Private instance method

    private func gesturesKey(forApp appPath: String) -> String {

        return "gesturesFor:\(appPath)"
    }

    private func keystrokeKey(forApp appPath: String, forGesture gestureString: String) -> String {

        return "keystrokeFor:\(appPath)/\(gestureString)"
    }

    private func setApps(paths: [String]) {

        self.userDefaults.set(paths, forKey: self.appPathsKey)
    }
    
    private func setApp(path: String) {
        
        var paths = self.appPaths
        guard !paths.contains(path) else { return }

        paths.append(path)
        self.setApps(paths: paths)
    }

    private func setGesture(forApp appPath: String, gestureString: String) {

        var gestures = self.gestures(forApp: appPath)
        guard !gestures.contains(gestureString) else { return }

        gestures.append(gestureString)
        let gesturesKey = self.gesturesKey(forApp: appPath)
        self.userDefaults.set(gestures, forKey: gesturesKey)
    }

    private func setKeystroke(forApp appPath: String, gestureString: String, keystrokeString: String) {

        let keystrokesKey = self.keystrokeKey(forApp: appPath, forGesture: gestureString)
        self.userDefaults.set(keystrokeString, forKey: keystrokesKey)
    }


    // MARK: Instance method

    func set(forApp path: String, command: Command) {

        self.setApp(path: path)
        self.setGesture(forApp: path, gestureString: command.gestureString)
        self.setKeystroke(forApp: path, gestureString: command.gestureString, keystrokeString: command.keystrokeString)
    }

    func gestures(forApp path: String) -> [String] {

        let gesturesKey = self.gesturesKey(forApp: path)
        
        guard let anyGestures = self.userDefaults.array(forKey: gesturesKey) else { return [] }
        guard let gestures = anyGestures as? [String] else { return [] }

        return gestures
    }

    func keystrokes(forApp path: String) -> [String] {

        let gestures = self.gestures(forApp: path)

        return gestures.map({

            let key = self.keystrokeKey(forApp: path, forGesture: $0)
            guard let anyKeystroke = self.userDefaults.object(forKey: key) else { return "" }
            guard let keystrokeString = anyKeystroke as? String else { return "" }

            return keystrokeString
        })
    }

    func keystroke(forApp path: String, gestureString: String) -> String? {

        let keystrokeKey = self.keystrokeKey(forApp: path, forGesture: gestureString)
        guard let anyKeystroke = self.userDefaults.object(forKey: keystrokeKey) else { return nil }

        return anyKeystroke as? String
    }

    func removeKeystroke(forApp path: String, gestureString: String) {
        
        let keystrokeKey = self.keystrokeKey(forApp: path, forGesture: gestureString)
        self.userDefaults.removeObject(forKey: keystrokeKey)
    }

    func removeGestures(forApp path: String) {

        let gestures = self.gestures(forApp: path)
        gestures.forEach({ self.removeKeystroke(forApp: path, gestureString: $0) })

        let gesturesKey = self.gesturesKey(forApp: path)
        self.userDefaults.removeObject(forKey: gesturesKey)
    }

    func removeApp(path: String) {

        self.removeGestures(forApp: path)
        self.setApps(paths: self.appPaths.filter({ $0 != path }))
    }

    func clearCompletely() {

        self.appPaths.forEach({ self.removeApp(path: $0) })
        self.setApps(paths: [])
    }
}
