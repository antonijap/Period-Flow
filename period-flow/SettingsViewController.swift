//
//  SettingsViewController.swift
//  period-flow
//
//  Created by Steven on 6/27/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets

    // Containers
    @IBOutlet weak var purchasesView: ShadowContainer!
    @IBOutlet weak var cycleDurationView: ShadowContainer!
    @IBOutlet weak var notificationsView: ShadowContainer!
    @IBOutlet weak var analysisBasisView: ShadowContainer!
    @IBOutlet weak var analysisView: ShadowContainer!
    
    // Label Contents
    @IBOutlet weak var purchaseProLabel: UILabel!
    @IBOutlet weak var proPackPriceLabel: UILabel!
    @IBOutlet weak var cycleDurationLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var analysisBasisLabel: UILabel!
    @IBOutlet weak var avgCycleDurationLabel: UILabel!
    @IBOutlet weak var avgPeriodDurationLabel: UILabel!
    @IBOutlet weak var avgCycleNumberLabel: UILabel!
    @IBOutlet weak var avgPeriodNumberLabel: UILabel!
    
    
    // MARK: - Properties
    
    var purchaseManager: PurchaseManager?

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPurchaseManager()
        setupContainers()
        configureLabels()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureAnalysisView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func setupPurchaseManager() {
        purchaseManager = PurchaseManager()
        purchaseManager?.requestProducts()
    }
    
    func addTapGestureTo(view: UIView, selector: Selector) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: selector)
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        view.userInteractionEnabled = true
    }
    
    func setupContainers() {
        addTapGestureTo(cycleDurationView, selector: #selector(SettingsViewController.displayDurationPicker))
        addTapGestureTo(notificationsView, selector: #selector(SettingsViewController.displayNotificationPicker))
        addTapGestureTo(analysisBasisView, selector: #selector(SettingsViewController.displayAnalysisPicker))
        addTapGestureTo(purchasesView, selector: #selector(SettingsViewController.purchaseProPackPressed))
    }
    
    func configureLabels() {
        let durationDays = DefaultsManager.getCycleDays()
        cycleDurationLabel.text = durationDays == 1 ? "1 day" : "\(durationDays) days"
        
        let analysisBasis = DefaultsManager.getAnalysisNumber()
        analysisBasisLabel.text = analysisBasis == 1 ? "Last Period" : "Last \(analysisBasis) periods"
        
        let notifDays = DefaultsManager.getNotificationDays()
        notificationsLabel.text = notifDays == 1 ? "1 day before period starts" : "\(notifDays) days before period starts"
    }
    
    func configureAnalysisView() {
        if let avgPeriodDuration = PeriodAnalysisManager.getAveragePeriodDuration() {
            avgPeriodNumberLabel.text = "\(avgPeriodDuration)"
        }
        if let avgCycleDuration = PeriodAnalysisManager.getAverageCycleDuration() {
            avgCycleNumberLabel.text = "\(avgCycleDuration)"
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
        let index = DefaultsManager.getCycleDays() - 1
        
        let picker = actionSheetFactory(title, rows: days, indexSelected: index, sender: cycleDurationView) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setCycleDays(object)
                self.cycleDurationLabel.text = object == 1 ? "1 day" : "\(object) days"
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
        
        let picker = actionSheetFactory(title, rows: days, indexSelected: index, sender: notificationsView) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setNotificationDays(object)
                LocalNotificationsManager.cancelAllNotifications()
                LocalNotificationsManager.registerNotification()
                self.notificationsLabel.text = object == 1 ? "1 day before period starts" : "\(object) days before period starts"
            }
        }
        picker.showActionSheetPicker()
    }
    
    /// Displays the picker to set the number of periods to base the analysis on
    func displayAnalysisPicker() {
        let title = "Number of Periods"
        let totalPeriods = RealmManager.sharedInstance.queryAllPeriods()?.count
        let rangeCap = totalPeriods ?? 1
        
        let range = (1...rangeCap).map { $0 }
        
        let picker = actionSheetFactory(title, rows: range, indexSelected: 0, sender: analysisView) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setAnalysisNumber(object)
                self.configureAnalysisView()
                self.analysisBasisLabel.text = object == 1 ? "Last Period" : "Last \(object) periods"
            }
        }
        picker.showActionSheetPicker()
    }
    
    /// Triggers the in app purchase for PRO pack product
    func purchaseProPackPressed() {
        if let product = purchaseManager?.products.first where product.productIdentifier == "com.antonijapek.periodflow.propack" {
            purchaseManager?.createPayment(product)
        }
    }
    
    // MARK: - IBActions

    @IBAction func backPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func restorePressed(sender: AnyObject) {
        purchaseManager?.restoreTransactions()
    }
}
