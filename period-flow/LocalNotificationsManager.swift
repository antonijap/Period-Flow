//
//  LocalNotificationsManager.swift
//  period-flow
//
//  Created by Steven on 6/27/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import SwiftDate

class LocalNotificationsManager {
    
    // FIXME: - Need to fill out content of notification
    
    /// Registers notification for specified date
    class func registerNotification() {
        let notification = UILocalNotification()
        notification.alertTitle = "Title"
        notification.alertBody = "This is the body of the message"
        notification.applicationIconBadgeNumber = 1
//        let date = getNotificationDate()
        let date = NSDate().dateByAddingTimeInterval(10)
        notification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print("Print notification: \(notification)")
    }

    /// Cancels all scheduled notifications
    class func cancelAllNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    // MARK: - Helper Methods
    
    /// Gets the specified date to send a notification, default value is one date before prediction date
    private class func getNotificationDate() -> NSDate? {
        guard let lastPeriod = RealmManager.sharedInstance.queryLastPeriod(), let predictionDate = lastPeriod.predictionDate else {
            return nil
        }
        let daysBefore = DefaultsManager.getNotificationDays()
        return predictionDate - daysBefore.days
    }
}
