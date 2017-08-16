//
//  GestureCommandsManager.swift
//  fflow
//
//  Created by user on 2016/10/08.
//  Copyright © 2016年 user. All rights reserved.
//

import Cocoa

class CommandPreference {

    static private func validUserDefaults(suiteName: String?) -> UserDefaults {

        guard let suiteName = suiteName else { return UserDefaults.standard }
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return UserDefaults.standard }

        return userDefaults
    }

    fileprivate let userDefaults: UserDefaults

    init(suiteName: String? = nil) {

        self.userDefaults = CommandPreference.validUserDefaults(suiteName: suiteName)
    }
}

protocol CanGetDefaults {

    var appPaths: [String] { get }
    func gestures(forApp path: String) -> [String]
    func keystroke(forApp path: String, gestureString: String) -> String?
    func keystroke(forApp url: URL, gesture: Gesture) -> String?
}

extension CanGetDefaults where Self: CommandPreference {

    static fileprivate var appPathsKey: String {

        return "appPaths"
    }

    static fileprivate func gesturesKey(forApp path: String) -> String {

        return "gesturesFor:\(path)"
    }

    static fileprivate func keystrokeKey(forApp path: String, forGesture gestureString: String) -> String {

        return "keystrokeFor:\(path)/\(gestureString)"
    }

    private func keystrokes(forApp path: String) -> [String] {

        let gestures = self.gestures(forApp: path)

        return gestures.map({

            let key = CommandPreference.keystrokeKey(forApp: path, forGesture: $0)
            guard let anyKeystroke = self.userDefaults.object(forKey: key) else { return "" }
            guard let keystrokeString = anyKeystroke as? String else { return "" }

            return keystrokeString
        })
    }

    var appPaths: [String] {

        guard let anyAppPaths = self.userDefaults.array(forKey: CommandPreference.appPathsKey) else { return [] }
        guard let appPaths = anyAppPaths as? [String] else { return [] }
        return appPaths
    }

    func gestures(forApp path: String) -> [String] {

        let gesturesKey = CommandPreference.gesturesKey(forApp: path)

        guard let anyGestures = self.userDefaults.array(forKey: gesturesKey) else { return [] }
        guard let gestures = anyGestures as? [String] else { return [] }

        return gestures
    }

    func keystroke(forApp path: String, gestureString: String) -> String? {

        let keystrokeKey = CommandPreference.keystrokeKey(forApp: path, forGesture: gestureString)
        guard let anyKeystroke = self.userDefaults.object(forKey: keystrokeKey) else { return nil }

        return anyKeystroke as? String
    }

    func keystroke(forApp url: URL, gesture: Gesture) -> String? {

        return self.keystroke(forApp: url.path, gestureString: gesture.string)
    }
}

protocol CanSetDefaults: CanGetDefaults {

    func setApp(path: String)
    func setGesture(forApp path: String, gestureString: String)
    func set(forApp path: String, gestureString: String, keystrokeString: String)
}

extension CanSetDefaults where Self: CommandPreference {

    fileprivate func setApps(paths: [String]) {

        self.userDefaults.set(paths, forKey: CommandPreference.appPathsKey)
    }

    fileprivate func setGestures(forApp path: String, gestures: [String]) {

        let gesturesKey = CommandPreference.gesturesKey(forApp: path)
        self.userDefaults.set(gestures, forKey: gesturesKey)
    }

    private func setKeystroke(forApp path: String, gestureString: String, keystrokeString: String) {

        let keystrokesKey = CommandPreference.keystrokeKey(forApp: path, forGesture: gestureString)
        self.userDefaults.set(keystrokeString, forKey: keystrokesKey)
    }

    func setApp(path: String) {

        var paths = self.appPaths
        guard !paths.contains(path) else { return }

        paths.append(path)
        self.setApps(paths: paths)
    }

    func setGesture(forApp path: String, gestureString: String) {

        var gestures = self.gestures(forApp: path)
        guard !gestures.contains(gestureString) else { return }

        gestures.append(gestureString)
        self.setGestures(forApp: path, gestures: gestures)
    }

    func set(forApp path: String, gestureString: String, keystrokeString: String) {

        self.setApp(path: path)
        self.setGesture(forApp: path, gestureString: gestureString)
        self.setKeystroke(forApp: path, gestureString: gestureString, keystrokeString: keystrokeString)
    }
}

protocol CanRemoveDefaults: CanSetDefaults {

    func removeApp(path: String)
    func removeGesture(forApp path: String, gestureString: String)
    func removeKeystroke(forApp path: String, gestureString: String)
}

extension CanRemoveDefaults where Self: CommandPreference {

    fileprivate func removeGestures(forApp path: String) {

        let gestures = self.gestures(forApp: path)
        gestures.forEach({ self.removeKeystroke(forApp: path, gestureString: $0) })

        let gesturesKey = CommandPreference.gesturesKey(forApp: path)
        self.userDefaults.removeObject(forKey: gesturesKey)
    }

    func removeApp(path: String) {

        self.removeGestures(forApp: path)
        self.setApps(paths: self.appPaths.filter({ $0 != path }))
    }

    func removeGesture(forApp path: String, gestureString: String) {

        self.removeKeystroke(forApp: path, gestureString: gestureString)

        var gestures = self.gestures(forApp: path)
        guard let index = gestures.index(of: gestureString) else { return }
        gestures.remove(at: index)
        self.setGestures(forApp: path, gestures: gestures)
    }

    func removeKeystroke(forApp path: String, gestureString: String) {

        let keystrokeKey = CommandPreference.keystrokeKey(forApp: path, forGesture: gestureString)
        self.userDefaults.removeObject(forKey: keystrokeKey)
    }
}

extension CommandPreference: CanRemoveDefaults {}

extension CommandPreference {

    func clearCompletely() {

        self.appPaths.forEach({ self.removeApp(path: $0) })
        self.setApps(paths: [])
    }

    func backToDefault() {

        self.clearCompletely()

        let shift = Key.Shift.symbol
        let control = Key.Control.symbol
        let option = Key.Option.symbol
        let command = Key.Command.symbol
        let tab = Key.Tab.symbol

        let global = AppItem.Global.path
        self.set(forApp: global, gestureString: "LRD", keystrokeString: "\(command)Q")

        let finder = AppItem.Finder.path
        self.set(forApp: finder, gestureString: "DR", keystrokeString: "\(command)W")

        let chrome = "/Applications/Google Chrome.app"
        self.set(forApp: chrome, gestureString: "DR", keystrokeString: "\(command)W")
        self.set(forApp: chrome, gestureString: "DRU", keystrokeString: "\(shift)\(command)T")
        self.set(forApp: chrome, gestureString: "DUR", keystrokeString: "\(command)T")
        self.set(forApp: chrome, gestureString: "DUL", keystrokeString: "\(shift)\(command)X")
        self.set(forApp: chrome, gestureString: "LURD", keystrokeString: "\(command)R")
        self.set(forApp: chrome, gestureString: "UR", keystrokeString: "\(option)\(command)→")
        self.set(forApp: chrome, gestureString: "UL", keystrokeString: "\(option)\(command)←")
        self.set(forApp: chrome, gestureString: "DLU", keystrokeString: "\(option)\(command)J")

        let safari = "/Applications/Safari.app"
        self.set(forApp: safari, gestureString: "DR", keystrokeString: "\(command)W")
        self.set(forApp: safari, gestureString: "LURD", keystrokeString: "\(command)R")
        self.set(forApp: safari, gestureString: "UR", keystrokeString: "\(control)\(tab)")
        self.set(forApp: safari, gestureString: "UL", keystrokeString: "\(control)\(shift)\(tab)")

        let atom = "/Applications/Atom.app"
        self.set(forApp: atom, gestureString: "DR", keystrokeString: "\(command)W")
        self.set(forApp: atom, gestureString: "UL", keystrokeString: "\(option)\(command)←")
        self.set(forApp: atom, gestureString: "UR", keystrokeString: "\(option)\(command)→")
        self.set(forApp: atom, gestureString: "DRU", keystrokeString: "\(shift)\(command)T")

        let dictionary = "/Applications/Dictionary.app"
        self.set(forApp: dictionary, gestureString: "DR", keystrokeString: "\(command)W")

        let xcode = "/Applications/Xcode.app"
        self.set(forApp: xcode, gestureString: "LDR", keystrokeString: "\(option)\(command)C")
        self.set(forApp: xcode, gestureString: "DRD", keystrokeString: "\(command)B")
        self.set(forApp: xcode, gestureString: "DRU", keystrokeString: "\(command)U")
    }
}
