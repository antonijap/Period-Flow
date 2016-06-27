//
//  DefaultsManager.swift
//  period-flow
//
//  Created by Antonija Pek on 12/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation

class DefaultsManager {
    
    /// Set cycleDuration in NSUserDefaults
    class func setCycleDays(value: Int) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: "cycleDays")
    }
    
    /// Get cycleDuration from NSUserDefaults
    class func getCycleDays() -> Int {
        return NSUserDefaults.standardUserDefaults().valueForKey("cycleDays") as? Int ?? 28
    }
    
    /// Set number of days before to receive notification in NSUserDefaults
    class func setNotificationDays(value: Int) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: "notificationDays")
    }
    
    /// Gets the number of days before to receive notifications from NSUserDefaults
    class func getNotificationDays() -> Int? {
        return NSUserDefaults.standardUserDefaults().valueForKey("notificationDays") as? Int
    }
    
    /// Sets the number of periods to use for the analysis
    class func setAnalysisNumber(value: Int) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: "analysisNumber")
    }
    
    /// Gets the number of periods to use for the analysis
    class func getAnalysisNumber() -> Int? {
        return NSUserDefaults.standardUserDefaults().valueForKey("analysisNumber") as? Int
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