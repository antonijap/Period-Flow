//
//  SettingsCell.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    // MARK: - Properties
    
    let purchased = DefaultsManager.isProPackUnlocked()

    // MARK: - Methods
    
    /// Configures the cell based on the section
    func configureForSection(section: Int) {
        switch section {
            case 0: configureCycleDaysRow()
            case 1: configurePurchasesRow()
            case 2: configureNotificationsRow()
            case 3: configureAnalysisRow()
            default: break
        }
    }
    
    /// Configures the cell title for the cycle duration
    func configureCycleDaysRow() {
        let cycleDays = DefaultsManager.getCycleDays()
        settingsLabel.text = "\(cycleDays)"
    }
    
    /// Configures the cell title for the purchases
    func configurePurchasesRow() {
        settingsLabel.text = purchased ? "PRO Pack Unlocked" : "PRO Pack Available"
    }
    
    /// Configures the cell title for the notifications and controls interaction
    func configureNotificationsRow() {
        let notifDays = DefaultsManager.getNotificationDays()
        let dayOrDays = notifDays == 1 ? "day" : "days"
        let title = "\(notifDays) \(dayOrDays) before period begins"
        
        settingsLabel.text = purchased ? title : "Unlock PRO Pack"
        self.userInteractionEnabled = purchased
    }
    
    /// Configures the cell title for the analysis and controls interaction
    func configureAnalysisRow() {
        let number = DefaultsManager.getAnalysisNumber()
        let title = number == 1 ? "Last period" : "Last \(number) period"
        
        settingsLabel.text = purchased ? title : "Unlock PRO Pack"
        self.userInteractionEnabled = purchased
    }
}
