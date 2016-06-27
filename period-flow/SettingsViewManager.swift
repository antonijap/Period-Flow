//
//  SettingsViewManager.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol SettingsViewManagerDelegate {
    func showPurchaseController() -> Void
}

class SettingsViewManager: NSObject {
    
    // MARK: - Properties
    
    var tableView: UITableView
    var delegate: SettingsViewManagerDelegate?
    
    // MARK: - Initializers
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - Methods
    
    /// Factory method to create an ActionSheetStringPicker with nil cancel block and trailing completion
    func actionSheetFactory(title: String, rows: [Int], indexSelected: Int, sender: AnyObject, completion: ActionStringDoneBlock) -> ActionSheetStringPicker {
        return ActionSheetStringPicker(title: title, rows: rows, initialSelection: indexSelected, doneBlock: completion, cancelBlock: nil, origin: sender)
    }
    
    /// Displays the picker to set the Cycle Duration
    func displayDurationPicker() {
        let title = "Cycle Duration"
        let days = (1...100).map { $0 }
        let currentDuration = DefaultsManager.getCycleDays()
        
        let picker = actionSheetFactory(title, rows: days, indexSelected: currentDuration, sender: tableView) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setCycleDays(object)
                self.tableView.reloadData()
            }
        }
        picker.showActionSheetPicker()
    }
    
    /// Displays the picker to set the number of days before a notification occurs
    func displayNotificationPicker() {
        let title = "Days Before"
        let currentDuration = DefaultsManager.getCycleDays()
        let days = (1...currentDuration).map { $0 }
        let notifDays = DefaultsManager.getNotificationDays()
        
        let picker = actionSheetFactory(title, rows: days, indexSelected: notifDays, sender: tableView) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setNotificationDays(object)
                self.tableView.reloadData()
            }
        }
        picker.showActionSheetPicker()
    }
    
    /// Displays the picker to set the number of periods to base the analysis on
    func displayAnalysisPicker() {
        let title = "Number of Periods"
        let currentNumber = DefaultsManager.getAnalysisNumber()
        let totalPeriods = RealmManager.sharedInstance.queryAllPeriods()?.count
        let rangeCap = totalPeriods > 0 ? totalPeriods! : currentNumber
        let range = (1...rangeCap).map { $0 }
        
        let picker = actionSheetFactory(title, rows: range, indexSelected: currentNumber, sender: tableView) { (picker, int, object) in
            if let object = object as? Int {
                DefaultsManager.setAnalysisNumber(object)
                self.tableView.reloadData()
            }
        }
        picker.showActionSheetPicker()
    }
}

extension SettingsViewManager: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            displayDurationPicker()
        case 1:
            delegate?.showPurchaseController()
        case 2:
            displayNotificationPicker()
        case 3 where indexPath.row == 0:
            displayAnalysisPicker()
        default: break
        }
    }
}
