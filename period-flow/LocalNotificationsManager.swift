//
//  LocalNotificationsManager.swift
//  period-flow
//
//  Created by Steven on 6/27/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import Foundation
import SwiftDate
import UserNotifications

class LocalNotificationsManager {

    @available(iOS 10.0, *)
    func scheduleNotification(at date: Date) {
        let calendar = Calendar.autoupdatingCurrent
//        let date = getNotificationDate()
        
        guard let lastPeriod = RealmManager.sharedInstance.queryLastPeriod(), let predictionDate = lastPeriod.predictionDate else {
            return
        }
        
//        let day = predictionDate.day - DefaultsManager.getNotificationDays()
        
//        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: predictionDate.month, day: day, hour: date?.hour, minute: date?.minute)
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let content = UNMutableNotificationContent()
        
        content.title = "Period Flow"
//        if DefaultsManager.getNotificationDays() == 1 {
//            content.body = "Period coming in \(DefaultsManager.getNotificationDays()) day!"
//        } else {
//            content.body = "Period coming in \(DefaultsManager.getNotificationDays()) days!"
//        }
        
        content.sound = UNNotificationSound.default()
        
//        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().add(request) {(error) in
//            if let error = error {
//                print("Uh oh! We had an error: \(error)")
//            }
//        }
    }
 

    /// Cancels all scheduled notifications
    class func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    // MARK: - Helper Methods
    
    /// Gets the specified date to send a notification, default value is one date before prediction date
//    func getNotificationDate() -> Date? {
//        let getDate = DefaultsManager.getNotificationTime()
//        return getDate // Return Created Date
//    }
}
