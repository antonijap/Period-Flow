//
//  NotificationPickerViewController.swift
//  period-flow
//
//  Created by Antonija on 08/10/2016.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import SwiftDate
import UserNotifications
import Foundation

@available(iOS 10.0, *)
class NotificationPickerViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timePickerStack: UIStackView!

    
    // MARK: Properties
    let localNotificationManager =  LocalNotificationsManager()
    var savedDate = Date()

    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timePicker.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//        checkForNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Methods
//    func checkForNotifications() {
//        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
//            if requests.isEmpty {
//                print("NO Notifications")
//                self.timePickerStack.alpha = 0.3
//                self.timePickerStack.isUserInteractionEnabled = false
//                self.configureLabel(number: 0.0)
//            } else {
//                print("There ARE Notifications")
//
//                self.configureLabel(number: Double(DefaultsManager.getNotificationDays()))
//                print("Get Notif. Days \(Double(DefaultsManager.getNotificationDays()))")
//                
//                guard let date = self.localNotificationManager.getNotificationDate() else {
//                    return
//                }
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = DateFormatter.Style.medium
//                let formattedDate = dateFormatter.string(from: date)
//                
//                self.savedDate = date
//                print("Saved date is \(formattedDate)")
//                self.timePicker.isUserInteractionEnabled = true
//
//                self.timePicker.date = date
//            }
//        })
//    }
    
    func configureLabel(number: Double) {
        if number == 1.0 {
            notifyLabel.text = "1 day before"
            notifyLabel.alpha = 1.0
            timePickerStack.isUserInteractionEnabled = true
            timePickerStack.alpha = 1
        } else if number == 0.0 {
            notifyLabel.text = "Don't notify me"
            notifyLabel.alpha = 0.5
            timePickerStack.isUserInteractionEnabled = false
            timePickerStack.alpha = 0.2
        } else {
            notifyLabel.text = "\(Int(number)) days before"
            notifyLabel.alpha = 1.0
            timePickerStack.isUserInteractionEnabled = true
            timePickerStack.alpha = 1
        }
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        configureLabel(number: sender.value)
        print("Stepper value is \(sender.value)")
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        sender.timeZone = TimeZone(secondsFromGMT: 0)!
    }
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        // Save new notification
        if notifyLabel.text != "Don't notify me" {
            // Check if date is in future
            if savedDate.isInPast {
                print("Can't save, date is in the past")
            } else {
                DefaultsManager.setNotificationDays(Int(stepper.value))
//                DefaultsManager.setNotificationTime(timePicker.date)
                localNotificationManager.scheduleNotification(at: timePicker.date)
            } 
        } else {
            print("Notification isn't saved")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeNotificationButtonTapped(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        dismiss(animated: true, completion: nil)
    }
}

