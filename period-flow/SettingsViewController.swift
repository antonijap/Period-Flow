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
import SwiftyStoreKit
import StoreKit

class SettingsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var notificationStack: UIStackView!
    @IBOutlet weak var analysisStack: UIStackView!
    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var notificationButtonsStack: UIStackView!

    @IBOutlet weak var purchaseBackground: UIView!

    @IBOutlet weak var averageCycleDurationLabel: UILabel!
    @IBOutlet weak var averagePeriodDurationLabel: UILabel!
    
    @IBOutlet weak var oneDayNotification: CustomButton!
    @IBOutlet weak var threeDaysNotification: CustomButton!
    @IBOutlet weak var fiveDaysNotification: CustomButton!
    @IBOutlet weak var nineAM: CustomButton!
    @IBOutlet weak var twelveAM: CustomButton!
    @IBOutlet weak var ninePM: CustomButton!
    @IBOutlet weak var removeNotificationButton: HollowButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cycleDurationButton: CustomButton!
    @IBOutlet weak var saveButton: FullButton!
    
    @IBOutlet weak var buyButton: UIButton!
    
    // MARK: - Properties
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseBackground.layer.cornerRadius = 4
        setupPurchaseManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAnalysisView()
        configureLabels()
        checkIfPurchased()
        checkForNotifications()
        setUpAnalytics()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            print(notifications)
        }
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.checkIfPurchased), name: Notification.Name("UpdateUI"), object: nil)
        
        print("PRO Pack purchased: \(DefaultsManager.isProPackUnlocked())")
        
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
        DispatchQueue.main.async() {
            if DefaultsManager.isProPackUnlocked() {
                // True
                // Show analysis and notifications
                print(DefaultsManager.isProPackUnlocked())
                self.notificationStack.isUserInteractionEnabled = true
                self.notificationStack.alpha = 1
                
                self.timeStack.isUserInteractionEnabled = true
                self.timeStack.alpha = 1
                
                self.notificationButtonsStack.isUserInteractionEnabled = true
                self.notificationButtonsStack.alpha = 1
                
                // Remove Buy button
                self.buyButton.isHidden = true
                
                self.configureAnalysisVisibility()
            } else {
                // False
                
                self.notificationStack.isUserInteractionEnabled = false
                self.notificationStack.alpha = 0.5
                
                self.timeStack.isUserInteractionEnabled = false
                self.timeStack.alpha = 0.5
                
                self.notificationButtonsStack.isUserInteractionEnabled = false
                self.notificationButtonsStack.alpha = 0.5
                
                self.configureAnalysisVisibility()
                
                self.buyButton.isHidden = false
            }
        }
    }
    
    func setupPurchaseManager() {
        
        SwiftyStoreKit.retrieveProductsInfo([PURCHASE_PROPACK]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                // Trigger Alert
                print("Invalid product identifier: \(invalidProductId)")
//                let alert = UIAlertController(title: "Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    /// Triggers the in app purchase for PRO pack product
    func purchaseProPackPressed() {
        
        SwiftyStoreKit.purchaseProduct(PURCHASE_PROPACK, atomically: true) { result in
            switch result {
            case .success(let product):
                print("Purchase Success: \(product.productId)")
                DefaultsManager.unlockProPack()
                self.checkIfPurchased()
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                }
            }
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
            
            sender.backgroundColor = UIColor(red:0.55, green:0.90, blue:0.54, alpha:1.00)
            let when = DispatchTime.now() + 0.4 // change to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                sender.backgroundColor = UIColor(red:0.17, green:0.57, blue:0.87, alpha:1.00)
            }
            
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

    
    @IBAction func buyProPack(_ sender: Any) {
        purchaseProPackPressed()
        checkIfPurchased()
    }
    
    @IBAction func restoreButtonTapped(_ sender: AnyObject) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedProducts.count > 0 {
                print("Restore Failed: \(results.restoreFailedProducts)")
            }
            else if results.restoredProducts.count > 0 {
                print("Restore Success: \(results.restoredProducts)")
            }
            else {
                print("Nothing to Restore")
            }
        }
        
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
                    self.saveButton.setTitle("Update", for: .normal)
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
                    self.saveButton.setTitle("Save", for: .normal)
                    
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
