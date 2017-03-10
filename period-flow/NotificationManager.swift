//
//  NotificationManager.swift
//  period-flow
//
//  Created by Steven on 2/11/17.
//  Copyright © 2017 Antonija Pek. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftDate

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
        
        let notificationDay = predictionDate - notifDays.days
        
        if notificationDay.isInFuture {
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: predictionDate.year, month: notificationDay.month, day: notificationDay.day, hour: notifTime, minute: 0) //FIXME: - Check if predictionDate.month is the same month as notification date!!!!!!!
            
            //        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: predictionDate.year, month: 3, day: 6, hour: 12, minute: 23)
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
            let content = UNMutableNotificationContent()
            
            content.title = "Period Flow"
            
            
            if DefaultsManager.getNotificationDays() == 1 {
                content.body = "Period coming in \(DefaultsManager.getNotificationDays()!) day!"
            } else {
                content.body = "Period coming in \(DefaultsManager.getNotificationDays()!) days!"
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
        

    }
    
    static func removeAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
