//
//  DefaultsManager.swift
//  period-flow
//
//  Created by Antonija Pek on 12/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation

class DefaultsManager {
    /// Set value in NSUserDefaults
    class func setCycleDays(value: Int) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: "cycleDays")
    }
    
    /// Get value from NSUserDefaults
    class func getCycleDays() -> Int {
        return NSUserDefaults.standardUserDefaults().valueForKey("cycleDays") as? Int ?? 28
    }
    
    /// Checks if PRO Pack in app purchase is unlocked
    class func isProPackUnlocked() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("proPack") ?? false
    }
    
    /// Unlocks the PRO Pack in app purchase
    class func unlockProPack() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "proPack")
    }
}