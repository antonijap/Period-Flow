//
//  ViewController.swift
//  period-flow
//
//  Created by Antonija Pek on 28/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureAnalysisView()
        configureLabels()
    }
    
    // MARK: Methods
    
    func setupPurchaseManager() {
        purchaseManager = PurchaseManager()
        purchaseManager?.requestProducts()
    }
    
    /// Triggers the in app purchase for PRO pack product
    func purchaseProPackPressed() {
        if let product = purchaseManager?.products.first where product.productIdentifier == PURCHASE_PROPACK {
            purchaseManager?.createPayment(product)
        }
    }
    
    /// Factory method to create an ActionSheetStringPicker with nil cancel block and trailing completion
    func actionSheetFactory(title: String, rows: [Int], indexSelected: Int, sender: AnyObject, completion: ActionStringDoneBlock) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: title, rows: rows, initialSelection: indexSelected, doneBlock: completion, cancelBlock: nil, origin: sender)
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
                self.cycleDurationButton.setTitle(text, forState: .Normal)
                self.configureAnalysisView()
            }
        }
        picker.showActionSheetPicker()
    }
    
    /// Displays the picker to set the number of days before a notification occurs
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
                self.notificationButton.setTitle(text, forState: .Normal)
            }
        }
        picker.showActionSheetPicker()
    }
    
    /// Displays the picker to set time of notification (optional, if this is not set use midnight)
    func displayNotificationTimePicker() {
        let timePicker = ActionSheetDatePicker(title: "Time", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), doneBlock: { (picker: ActionSheetDatePicker!, date: AnyObject!, object: AnyObject!) in
            // MARK: - TODO
            // Save selected time in defaults manager
            // Update the notification to use that selected time
            
            }, cancelBlock: nil, origin: notificationTimeButton)
        timePicker.minuteInterval = 30
        timePicker.showActionSheetPicker()
    }
    
    func timePicked() {
        print("Time")
    }
    
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
                self.baseAnalysisButton.setTitle(text, forState: .Normal)
            }
        }
        picker.showActionSheetPicker()
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
        self.cycleDurationButton.setTitle(durationText, forState: .Normal)
        
        let analysisBasis = DefaultsManager.getAnalysisNumber()
        let totalPeriods = RealmManager.sharedInstance.queryAllPeriods()?.count
        if totalPeriods == 0 {
            let text = "No data, please tap on a date to start"
            self.baseAnalysisButton.setTitle(text, forState: .Normal)
            baseAnalysisButton.userInteractionEnabled = false
            baseAnalysisButton.alpha = 0.5
            
            averageCycleDurationLabel.text = "No data"
            averagePeriodDurationLabel.text = "No data"
        } else {
            let analysisText = analysisBasis == 1 ? "Last Period" : "Last \(analysisBasis) periods"
            self.baseAnalysisButton.setTitle(analysisText, forState: .Normal)
        }
        
        
        let notifDays = DefaultsManager.getNotificationDays()
        let notifText = notifDays == 1 ? "1 day before period starts" : "\(notifDays) days before period starts"
        self.notificationButton.setTitle(notifText, forState: .Normal)
    }

    // MARK: Actions

    @IBAction func cycleDurationButtonTapped(sender: AnyObject) {
        displayDurationPicker()
    }
    
    @IBAction func notificationButtonTapped(sender: AnyObject) {
        displayNotificationPicker()
    }
    
    @IBAction func notificationTimeButtonTapped(sender: AnyObject) {
        displayNotificationTimePicker()
    }
    
    @IBAction func baseAnalysisButtonTapped(sender: AnyObject) {
        displayAnalysisPicker()
    }
    
    @IBAction func purchaseTapped(sender: AnyObject) {
        purchaseProPackPressed()
    }
    
    @IBAction func restoreButtonTapped(sender: AnyObject) {
        purchaseManager?.restoreTransactions()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
