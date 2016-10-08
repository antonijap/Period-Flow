//
//  ViewController.swift
//  period-flow
//
//  Created by Antonija Pek on 28/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftDate

class SettingsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var notificationStack: UIStackView!
    @IBOutlet weak var baseAnalysisStack: UIStackView!
    @IBOutlet weak var analysisStack: UIStackView!
    @IBOutlet weak var purchaseStack: UIStackView!
    
    @IBOutlet weak var averageCycleDurationLabel: UILabel!
    @IBOutlet weak var averagePeriodDurationLabel: UILabel!
    
    @IBOutlet weak var cycleDurationButton: CustomButton!
    @IBOutlet weak var notificationButton: CustomButton!
    @IBOutlet weak var baseAnalysisButton: CustomButton!
    @IBOutlet weak var notificationTimeButton: CustomButton!

    // MARK: - Properties
    
    var purchaseManager: PurchaseManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPurchaseManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAnalysisView()
        configureLabels()
        checkIfPurchased()
        print("PRO Pack purchased: \(DefaultsManager.isProPackUnlocked())")
    }
    
    // MARK: Methods
    
    func checkIfPurchased() {
        if DefaultsManager.isProPackUnlocked() {
            // True
            // Show analysis and notifications
            
            notificationStack.isUserInteractionEnabled = true
            notificationStack.alpha = 1
            
            baseAnalysisStack.isUserInteractionEnabled = true
            baseAnalysisStack.alpha = 1
            
            baseAnalysisButton.isUserInteractionEnabled = true
            baseAnalysisButton.alpha = 1
            
            analysisStack.isUserInteractionEnabled = true
            analysisStack.alpha = 1
        } else {
            notificationStack.isUserInteractionEnabled = false
            notificationStack.alpha = 0.5
            
            baseAnalysisStack.isUserInteractionEnabled = false
            baseAnalysisStack.alpha = 0.5
            
            analysisStack.isUserInteractionEnabled = false
            analysisStack.alpha = 0.5
        }
    }
    
    func setupPurchaseManager() {
        purchaseManager = PurchaseManager()
        purchaseManager?.requestProducts()
    }
    
    /// Triggers the in app purchase for PRO pack product
    func purchaseProPackPressed() {
        if let product = purchaseManager?.products.first , product.productIdentifier == PURCHASE_PROPACK {
            purchaseManager?.createPayment(product)
        }
    }
    
    /// Factory method to create an ActionSheetStringPicker with nil cancel block and trailing completion
    func actionSheetFactory(_ title: String, rows: [Int], indexSelected: Int, sender: AnyObject, completion: @escaping ActionStringDoneBlock) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: title, rows: rows, initialSelection: indexSelected, doneBlock: completion, cancel: nil, origin: sender)
    }
    
    /// Displays the picker to set the Cycle Duration
    func displayDurationPicker() {
        let title = "Cycle Duration"
        let days = (1...100).map { $0 }
        let index = DefaultsManager.getCycleDays()
        
        let picker = actionSheetFactory(title, rows: days, indexSelected: index - 1, sender: cycleDurationButton) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setCycleDays(object)
                let text = object == 1 ? "1 day" : "\(object) days"
                self.cycleDurationButton.setTitle(text, for: UIControlState())
                self.configureAnalysisView()
            }
        }
        picker.show()
    }
    
    /// Displays the picker to set the number of days before a notification occurs
    // TODO: Add hours and/or minutes to this picker
    func displayNotificationPicker() {
        let title = "Days Before"
        let currentDuration = DefaultsManager.getCycleDays()
        let days = (1...currentDuration).map { $0 }
        let index = DefaultsManager.getNotificationDays() - 1
        
        let picker = actionSheetFactory(title, rows: days, indexSelected: index, sender: notificationButton) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setNotificationDays(object)
                LocalNotificationsManager.cancelAllNotifications()
                LocalNotificationsManager.registerNotification()
                let text = object == 1 ? "1 day before period starts" : "\(object) days before period starts"
                self.notificationButton.setTitle(text, for: UIControlState())
            }
        }
        picker.show()
    }
    
//    /// Displays the picker to set time of notification (optional, if this is not set use midnight)
//    func displayNotificationTimePicker() {
//        let timePicker = ActionSheetDatePicker(title: "Time", datePickerMode: UIDatePickerMode.time, selectedDate: Date(), doneBlock: { (picker: ActionSheetDatePicker!, date: AnyObject!, object: AnyObject!) in
//            // MARK: - TODO
//            // Save selected time in defaults manager
//            // Update the notification to use that selected time
//            
//            print("I PICKED: \(date)")
//            
//            }, cancel: nil, origin: notificationTimeButton)
//        timePicker.minuteInterval = 30
//        timePicker.show()
//    }
//    
//    func timePicked() {
//        print("Time")
//    }
    
    /// Displays the picker to set the number of periods to base the analysis on
    func displayAnalysisPicker() {
        let title = "Number of Periods"
        let totalPeriods = RealmManager.sharedInstance.queryAllPeriods()?.count
        
        let rangeStart = totalPeriods == 0 ? 0 : 1
        let rangeCap = totalPeriods ?? 1
        
        let range = (rangeStart...rangeCap).map { $0 }
        
        let picker = actionSheetFactory(title, rows: range, indexSelected: 0, sender: baseAnalysisButton) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setAnalysisNumber(object)
                self.configureAnalysisView()
                let text = object == 1 ? "Last Period" : "Last \(object) periods"
                self.baseAnalysisButton.setTitle(text, for: UIControlState())
            }
        }
        picker.show()
    }
    
    /// Configures the analyis view with the data
    func configureAnalysisView() {
        if let avgPeriodDuration = PeriodAnalysisManager.getAveragePeriodDuration() {
            averagePeriodDurationLabel.text = "\(avgPeriodDuration.toPlaces(1))"
        }
        if let avgCycleDuration = PeriodAnalysisManager.getAverageCycleDuration() {
            averageCycleDurationLabel.text = "\(avgCycleDuration.toPlaces(1))"
        }
    }
    
    /// Manage labels on any update
    func configureLabels() {
        let durationDays = DefaultsManager.getCycleDays()
        let durationText = durationDays == 1 ? "1 day" : "\(durationDays) days"
        self.cycleDurationButton.setTitle(durationText, for: UIControlState())
        
        let analysisBasis = DefaultsManager.getAnalysisNumber()
        let totalPeriods = RealmManager.sharedInstance.queryAllPeriods()?.count
        if totalPeriods == 0 {
            let text = "No data, please tap on a date to start"
            self.baseAnalysisButton.setTitle(text, for: UIControlState())
            baseAnalysisButton.isUserInteractionEnabled = false
            baseAnalysisButton.alpha = 0.5
            
            averageCycleDurationLabel.text = "No data"
            averagePeriodDurationLabel.text = "No data"
        } else {
            let analysisText = analysisBasis == 1 ? "Last Period" : "Last \(analysisBasis) periods"
            self.baseAnalysisButton.setTitle(analysisText, for: UIControlState())
        }
        
        
        let notifDays = DefaultsManager.getNotificationDays()
        let notifText = notifDays == 1 ? "1 day before period starts" : "\(notifDays) days before period starts"
        self.notificationButton.setTitle(notifText, for: UIControlState())
    }

    // MARK: Actions

    @IBAction func cycleDurationButtonTapped(_ sender: AnyObject) {
        displayDurationPicker()
    }
    
    @IBAction func notificationButtonTapped(_ sender: AnyObject) {
        displayNotificationPicker()
    }
    
    @IBAction func notificationTimeButtonTapped(_ sender: AnyObject) {
//        displayNotificationTimePicker()
    }
    
    @IBAction func baseAnalysisButtonTapped(_ sender: AnyObject) {
        displayAnalysisPicker()
    }
    
    @IBAction func purchaseTapped(_ sender: AnyObject) {
        purchaseProPackPressed()
    }
    
    @IBAction func restoreButtonTapped(_ sender: AnyObject) {
        purchaseManager?.restoreTransactions()
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
