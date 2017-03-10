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
    class func setCycleDays(_ value: Int) {
        UserDefaults.standard.setValue(value, forKey: KEY_CYCLE_DAYS)
    }
    
    /// Get cycleDuration from NSUserDefaults
    class func getCycleDays() -> Int {
        return UserDefaults.standard.value(forKey: KEY_CYCLE_DAYS) as? Int ?? 28
    }
    
    /// Set number of days before to receive notification in UserDefaults
    class func setNotificationDays(_ value: Int) {
        UserDefaults.standard.setValue(value, forKey: NOTIFICATION_DAYS)
    }
    
    /// Gets the number of days before to receive notifications from UserDefaults
    class func getNotificationDays() -> Int? {
        return UserDefaults.standard.value(forKey: NOTIFICATION_DAYS) as? Int
    }
    
    /// Gets the time to receive notifications from UserDefaults
    class func getNotificationTime() -> Int? {
        return UserDefaults.standard.value(forKey: "NotificationTime") as? Int
    }
    
    /// Set time to receive notification in NSUserDefaults
    class func setNotificationTime(_ value: Int) {
        UserDefaults.standard.setValue(value, forKey: "NotificationTime")
    }
    
    /// Sets the number of periods to use for the analysis
    class func setAnalysisNumber(_ value: Int) {
        UserDefaults.standard.setValue(value, forKey: KEY_ANALYSIS)
    }
    
    /// Gets the number of periods to use for the analysis
    class func getAnalysisNumber() -> Int {
        let totalPeriods = RealmManager.sharedInstance.realm.objects(Period.self).count
        let storedNumber = UserDefaults.standard.value(forKey: KEY_ANALYSIS) as? Int ?? totalPeriods
        return storedNumber > totalPeriods ? totalPeriods : storedNumber
    }
    
    /// Saves Date for Notification Date
    class func setNotifictionDate(_ date: DateComponents) {
        UserDefaults.standard.setValue(date, forKey: "NotificationDate")
    }
    
    class func getNotifictionDate() -> DateComponents? {
        return UserDefaults.standard.value(forKey: "NotificationDate") as? DateComponents
    }
    
    
    
    /// Checks if PRO Pack in app purchase is unlocked
    class func isProPackUnlocked() -> Bool {
        return UserDefaults.standard.bool(forKey: KEY_PRO_PACK) 
//        return true
    }
    
    /// Unlocks the PRO Pack in app purchase
    class func unlockProPack() {
        UserDefaults.standard.set(true, forKey: KEY_PRO_PACK)
    }
}
