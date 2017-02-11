//
//  NotificationManager.swift
//  period-flow
//
//  Created by Steven on 2/11/17.
//  Copyright © 2017 Antonija Pek. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static func notificationsExist(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            completion(notifications.count > 0)
        }
    }
    
    static func scheduleNotifications() {
        let calendar = Calendar.autoupdatingCurrent
        
        guard let lastPeriod = RealmManager.sharedInstance.queryLastPeriod(), let predictionDate = lastPeriod.predictionDate else {
            return
        }
        
        guard let notifDays = DefaultsManager.getNotificationDays() else {
            return
        }
        
        guard let notifTime = DefaultsManager.getNotificationTime() else {
            return
        }
        
        let day = predictionDate.day - notifDays
        
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: predictionDate.year, month: predictionDate.month, day: day, hour: notifTime, minute: 15)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        let content = UNMutableNotificationContent()
        
        content.title = "Period Flow"
        
        
        if DefaultsManager.getNotificationDays() == 1 {
            content.body = "Period coming in \(DefaultsManager.getNotificationDays()) day!"
        } else {
            content.body = "Period coming in \(DefaultsManager.getNotificationDays()) days!"
        }
        
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "\(time)", content: content, trigger: trigger)
        
        // Removes all notifications before scheduling the next
        removeAllScheduledNotifications()
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            } else {
                print(request)
            }
        }
    }
    
    static func removeAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
