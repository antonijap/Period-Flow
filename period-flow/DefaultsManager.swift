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
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: KEY_CYCLE_DAYS)
    }
    
    /// Get cycleDuration from NSUserDefaults
    class func getCycleDays() -> Int {
        return NSUserDefaults.standardUserDefaults().valueForKey(KEY_CYCLE_DAYS) as? Int ?? 28
    }
    
    /// Set number of days before to receive notification in NSUserDefaults
    class func setNotificationDays(value: Int) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: KEY_NOTIF_DAYS)
    }
    
    /// Gets the number of days before to receive notifications from NSUserDefaults
    class func getNotificationDays() -> Int {
        return NSUserDefaults.standardUserDefaults().valueForKey(KEY_NOTIF_DAYS) as? Int ?? 1
    }
    
    /// Sets the number of periods to use for the analysis
    class func setAnalysisNumber(value: Int) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: KEY_ANALYSIS)
    }
    
    /// Gets the number of periods to use for the analysis
    class func getAnalysisNumber() -> Int {
        let totalPeriods = RealmManager.sharedInstance.realm.objects(Period).count
        let storedNumber = NSUserDefaults.standardUserDefaults().valueForKey(KEY_ANALYSIS) as? Int ?? totalPeriods
        return storedNumber > totalPeriods ? totalPeriods : storedNumber
    }
    
    /// Checks if PRO Pack in app purchase is unlocked
    class func isProPackUnlocked() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(KEY_PRO_PACK) ?? false
    }
    
    /// Unlocks the PRO Pack in app purchase
    class func unlockProPack() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: KEY_PRO_PACK)
    }
}