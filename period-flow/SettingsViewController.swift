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
import UserNotifications

class SettingsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var notificationStack: UIStackView!
    @IBOutlet weak var analysisStack: UIStackView!
    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var notificationButtonsStack: UIStackView!
    
    @IBOutlet weak var purchaseStack: UIStackView!
    
    @IBOutlet weak var averageCycleDurationLabel: UILabel!
    @IBOutlet weak var averagePeriodDurationLabel: UILabel!
    
    @IBOutlet weak var oneDayNotification: CustomButton!
    @IBOutlet weak var threeDaysNotification: CustomButton!
    @IBOutlet weak var fiveDaysNotification: CustomButton!
    @IBOutlet weak var nineAM: CustomButton!
    @IBOutlet weak var twelveAM: CustomButton!
    @IBOutlet weak var ninePM: CustomButton!
    @IBOutlet weak var removeNotificationButton: HollowButton!
    
    
    @IBOutlet weak var cycleDurationButton: CustomButton!
    
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
        checkForNotifications()
        setUpAnalytics()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.checkIfPurchased), name: Notification.Name("UpdateUI"), object: nil)
        
        print("PRO Pack purchased: \(DefaultsManager.isProPackUnlocked())")
        
        print(DefaultsManager.getNotificationTime() ?? 9999)
        print(DefaultsManager.getNotificationDays() ?? 9999)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Methods
    
    func setUpAnalytics() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Settings Screen")
        let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
        tracker?.send(build)
    }
    
    func checkIfPurchased() {
        if DefaultsManager.isProPackUnlocked() {
            // True
            // Show analysis and notifications
            print(DefaultsManager.isProPackUnlocked())
            notificationStack.isUserInteractionEnabled = true
            notificationStack.alpha = 1
            
            timeStack.isUserInteractionEnabled = true
            timeStack.alpha = 1
            
            notificationButtonsStack.isUserInteractionEnabled = true
            notificationButtonsStack.alpha = 1
            
            configureAnalysisVisibility()
        } else {
            // False
            
            notificationStack.isUserInteractionEnabled = false
            notificationStack.alpha = 0.5
            
            timeStack.isUserInteractionEnabled = false
            timeStack.alpha = 0.5
            
            notificationButtonsStack.isUserInteractionEnabled = false
            notificationButtonsStack.alpha = 0.5
            
            configureAnalysisVisibility()
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
    }
    
    func configureAnalysisVisibility() {
        let totalPeriods = RealmManager.sharedInstance.queryAllPeriods()?.count
        if totalPeriods == 0 {
            averageCycleDurationLabel.text = "No data"
            averagePeriodDurationLabel.text = "No data"
            analysisStack.isUserInteractionEnabled = false
            analysisStack.alpha = 0.5
        } else {
            analysisStack.isUserInteractionEnabled = true
            analysisStack.alpha = 1
        }
    }
    
    // MARK: Actions
    
    @IBAction func oneDayButtonSelected(_ sender: UIButton) {
        // Toggle selection
        if sender.layer.borderColor == Color.blue.cgColor {
            // Button is selected
            sender.layer.borderColor = Color.borderColor.cgColor
            oneDayNotification.setTitleColor(Color.grey, for: .normal)
            
        } else {
            sender.layer.borderColor = Color.blue.cgColor
            oneDayNotification.setTitleColor(Color.blue, for: .normal)
            
            // Disable other buttons
            threeDaysNotification.layer.borderColor = Color.borderColor.cgColor
            threeDaysNotification.setTitleColor(Color.grey, for: .normal)
            
            fiveDaysNotification.layer.borderColor = Color.borderColor.cgColor
            fiveDaysNotification.setTitleColor(Color.grey, for: .normal)
            
            // Save how many days before period will notification show
            DefaultsManager.setNotificationDays(sender.tag)
        }
    }
    
    @IBAction func threeDaysButtonSelected(_ sender: UIButton) {
        if sender.layer.borderColor == Color.blue.cgColor {
            sender.layer.borderColor = Color.borderColor.cgColor
            threeDaysNotification.setTitleColor(Color.grey, for: .normal)
            
        } else {
            sender.layer.borderColor = Color.blue.cgColor
            threeDaysNotification.setTitleColor(Color.blue, for: .normal)
            
            // Disable other buttons
            oneDayNotification.layer.borderColor = Color.borderColor.cgColor
            oneDayNotification.setTitleColor(Color.grey, for: .normal)
            
            fiveDaysNotification.layer.borderColor = Color.borderColor.cgColor
            fiveDaysNotification.setTitleColor(Color.grey, for: .normal)
            
            // Save how many days before period will notification show
            DefaultsManager.setNotificationDays(sender.tag)
        }
    }
    
    @IBAction func fiveDaysButtonSelected(_ sender: UIButton) {
        if sender.layer.borderColor == Color.blue.cgColor {
            sender.layer.borderColor = Color.borderColor.cgColor
            fiveDaysNotification.setTitleColor(Color.grey, for: .normal)
            
        } else {
            sender.layer.borderColor = Color.blue.cgColor
            fiveDaysNotification.setTitleColor(Color.blue, for: .normal)
            
            // Disable other buttons
            oneDayNotification.layer.borderColor = Color.borderColor.cgColor
            oneDayNotification.setTitleColor(Color.grey, for: .normal)
            
            threeDaysNotification.layer.borderColor = Color.borderColor.cgColor
            threeDaysNotification.setTitleColor(Color.grey, for: .normal)
            
            // Save how many days before period will notification show
            DefaultsManager.setNotificationDays(sender.tag)
        }
    }
    
    @IBAction func nineAMbuttonSelected(_ sender: UIButton) {
        if sender.layer.borderColor == Color.blue.cgColor {
            sender.layer.borderColor = Color.borderColor.cgColor
            nineAM.setTitleColor(Color.grey, for: .normal)
            
        } else {
            sender.layer.borderColor = Color.blue.cgColor
            nineAM.setTitleColor(Color.blue, for: .normal)
            
            // Disable other buttons
            twelveAM.layer.borderColor = Color.borderColor.cgColor
            twelveAM.setTitleColor(Color.grey, for: .normal)
            
            ninePM.layer.borderColor = Color.borderColor.cgColor
            ninePM.setTitleColor(Color.grey, for: .normal)
            
            // Save Time
            DefaultsManager.setNotificationTime(sender.tag)
        }
    }
    
    @IBAction func twelveAMButtonSelected(_ sender: UIButton) {
        if sender.layer.borderColor == Color.blue.cgColor {
            sender.layer.borderColor = Color.borderColor.cgColor
            twelveAM.setTitleColor(Color.grey, for: .normal)
            
        } else {
            sender.layer.borderColor = Color.blue.cgColor
            twelveAM.setTitleColor(Color.blue, for: .normal)
            
            // Disable other buttons
            nineAM.layer.borderColor = Color.borderColor.cgColor
            nineAM.setTitleColor(Color.grey, for: .normal)
            
            ninePM.layer.borderColor = Color.borderColor.cgColor
            ninePM.setTitleColor(Color.grey, for: .normal)
            
            // Save Time
            DefaultsManager.setNotificationTime(sender.tag)
        }
    }
    
    @IBAction func ninePMButtonSelected(_ sender: UIButton) {
        if sender.layer.borderColor == Color.blue.cgColor {
            sender.layer.borderColor = Color.borderColor.cgColor
            ninePM.setTitleColor(Color.grey, for: .normal)
            
        } else {
            sender.layer.borderColor = Color.blue.cgColor
            ninePM.setTitleColor(Color.blue, for: .normal)
            
            // Disable other buttons
            nineAM.layer.borderColor = Color.borderColor.cgColor
            nineAM.setTitleColor(Color.grey, for: .normal)
            
            twelveAM.layer.borderColor = Color.borderColor.cgColor
            twelveAM.setTitleColor(Color.grey, for: .normal)
            
            // Save Time
            DefaultsManager.setNotificationTime(sender.tag)
        }
    }
    
    @IBAction func saveNotificationPressed(_ sender: UIButton) {
        // Get Days And Time
        if nineAM.layer.borderColor == Color.borderColor.cgColor, twelveAM.layer.borderColor == Color.borderColor.cgColor, ninePM.layer.borderColor == Color.borderColor.cgColor, threeDaysNotification.layer.borderColor == Color.borderColor.cgColor, fiveDaysNotification.layer.borderColor == Color.borderColor.cgColor, oneDayNotification.layer.borderColor == Color.borderColor.cgColor {
            // Nothing is selected
            // Trigger Alert
            let alert = UIAlertController(title: "Ooops", message: "You have to select day and time to save notification.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            scheduleNotification()
            
            // Will check for notifications and display remove button
            checkForNotifications()
        }
        
    }
    
    @IBAction func removeNotificationPressed(_ sender: UIButton) {
        // Remove notifications, if there are nay
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        checkForNotifications()
    }
    
    @IBAction func cycleDurationButtonTapped(_ sender: AnyObject) {
        displayDurationPicker()
    }
    
    @IBAction func purchaseTapped(_ sender: AnyObject) {
        purchaseProPackPressed()
        checkIfPurchased()
    }
    
    @IBAction func restoreButtonTapped(_ sender: AnyObject) {
        purchaseManager?.restoreTransactions()
        checkIfPurchased()
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Notification Helper Methods

extension SettingsViewController {
    
    func scheduleNotification() {
        NotificationManager.scheduleNotifications()
    }
    
    func checkForNotifications() {
        
        NotificationManager.notificationsExist { (notifsExist) in
            
            if notifsExist {
                DispatchQueue.main.async() {
                    self.removeNotificationButton.isHidden = false
                    guard let day = DefaultsManager.getNotificationDays() else {
                        return
                    }
                    
                    guard let time = DefaultsManager.getNotificationTime() else {
                        return
                    }
                    
                    if day == 1 {
                        self.oneDayNotification.layer.borderColor = Color.blue.cgColor
                        self.oneDayNotification.setTitleColor(Color.blue, for: .normal)
                        
                        // Disable other buttons
                        self.threeDaysNotification.layer.borderColor = Color.borderColor.cgColor
                        self.threeDaysNotification.setTitleColor(Color.grey, for: .normal)
                        
                        self.fiveDaysNotification.layer.borderColor = Color.borderColor.cgColor
                        self.fiveDaysNotification.setTitleColor(Color.grey, for: .normal)
                    } else if day == 3 {
                        self.threeDaysNotification.layer.borderColor = Color.blue.cgColor
                        self.threeDaysNotification.setTitleColor(Color.blue, for: .normal)
                        
                        // Disable other buttons
                        self.oneDayNotification.layer.borderColor = Color.borderColor.cgColor
                        self.oneDayNotification.setTitleColor(Color.grey, for: .normal)
                        
                        self.fiveDaysNotification.layer.borderColor = Color.borderColor.cgColor
                        self.fiveDaysNotification.setTitleColor(Color.grey, for: .normal)
                    } else if day == 5 {
                        self.fiveDaysNotification.layer.borderColor = Color.blue.cgColor
                        self.fiveDaysNotification.setTitleColor(Color.blue, for: .normal)
                        
                        // Disable other buttons
                        self.oneDayNotification.layer.borderColor = Color.borderColor.cgColor
                        self.oneDayNotification.setTitleColor(Color.grey, for: .normal)
                        
                        self.threeDaysNotification.layer.borderColor = Color.borderColor.cgColor
                        self.threeDaysNotification.setTitleColor(Color.grey, for: .normal)
                    } else {
                        // Disable other buttons
                        self.oneDayNotification.layer.borderColor = Color.borderColor.cgColor
                        self.oneDayNotification.setTitleColor(Color.grey, for: .normal)
                        
                        self.threeDaysNotification.layer.borderColor = Color.borderColor.cgColor
                        self.threeDaysNotification.setTitleColor(Color.grey, for: .normal)
                        
                        self.fiveDaysNotification.layer.borderColor = Color.borderColor.cgColor
                        self.fiveDaysNotification.setTitleColor(Color.grey, for: .normal)
                    }
                    
                    if time == 9 {
                        self.nineAM.layer.borderColor = Color.blue.cgColor
                        self.nineAM.setTitleColor(Color.blue, for: .normal)
                        
                        // Disable other buttons
                        self.twelveAM.layer.borderColor = Color.borderColor.cgColor
                        self.twelveAM.setTitleColor(Color.grey, for: .normal)
                        
                        self.ninePM.layer.borderColor = Color.borderColor.cgColor
                        self.ninePM.setTitleColor(Color.grey, for: .normal)
                    } else if time == 12 {
                        self.twelveAM.layer.borderColor = Color.blue.cgColor
                        self.twelveAM.setTitleColor(Color.blue, for: .normal)
                        
                        // Disable other buttons
                        self.nineAM.layer.borderColor = Color.borderColor.cgColor
                        self.nineAM.setTitleColor(Color.grey, for: .normal)
                        
                        self.ninePM.layer.borderColor = Color.borderColor.cgColor
                        self.ninePM.setTitleColor(Color.grey, for: .normal)
                    } else if time == 21 {
                        self.ninePM.layer.borderColor = Color.blue.cgColor
                        self.ninePM.setTitleColor(Color.blue, for: .normal)
                        
                        // Disable other buttons
                        self.twelveAM.layer.borderColor = Color.borderColor.cgColor
                        self.twelveAM.setTitleColor(Color.grey, for: .normal)
                        
                        self.nineAM.layer.borderColor = Color.borderColor.cgColor
                        self.nineAM.setTitleColor(Color.grey, for: .normal)
                    } else {
                        // Disable other buttons
                        self.twelveAM.layer.borderColor = Color.borderColor.cgColor
                        self.twelveAM.setTitleColor(Color.grey, for: .normal)
                        
                        self.ninePM.layer.borderColor = Color.borderColor.cgColor
                        self.ninePM.setTitleColor(Color.grey, for: .normal)
                        
                        self.nineAM.layer.borderColor = Color.borderColor.cgColor
                        self.nineAM.setTitleColor(Color.grey, for: .normal)
                    }
                }
            } else {
                DispatchQueue.main.async(){
                    self.removeNotificationButton.isHidden = true
                    
                    self.oneDayNotification.layer.borderColor = Color.borderColor.cgColor
                    self.oneDayNotification.setTitleColor(Color.grey, for: .normal)
                    
                    self.threeDaysNotification.layer.borderColor = Color.borderColor.cgColor
                    self.threeDaysNotification.setTitleColor(Color.grey, for: .normal)
                    
                    self.fiveDaysNotification.layer.borderColor = Color.borderColor.cgColor
                    self.fiveDaysNotification.setTitleColor(Color.grey, for: .normal)
                    
                    self.twelveAM.layer.borderColor = Color.borderColor.cgColor
                    self.twelveAM.setTitleColor(Color.grey, for: .normal)
                    
                    self.ninePM.layer.borderColor = Color.borderColor.cgColor
                    self.ninePM.setTitleColor(Color.grey, for: .normal)
                    
                    self.nineAM.layer.borderColor = Color.borderColor.cgColor
                    self.nineAM.setTitleColor(Color.grey, for: .normal)
                }
            }
        }
    }
}

