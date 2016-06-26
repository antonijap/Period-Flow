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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureForSection(section: Int) {
        switch section {
            case 0: configureCycleDaysRow()
            case 1: configurePurchasesRow()
            case 2: configureNotificationsRow()
            case 3: configureAnalysisRow()
            default: break
        }
    }
    
    func configureCycleDaysRow() {
        let cycleDays = DefaultsManager.getCycleDays()
        settingsLabel.text = "\(cycleDays)"
    }
    
    func configurePurchasesRow() {
        settingsLabel.text = purchased ? "PRO Pack Unlocked" : "PRO Pack Available for Purchase"
    }
    

    func configureNotificationsRow() {
        settingsLabel.text = purchased ? "Unlocked" : "Unavailable - Unlock PRO Pack"
    }
    
    func configureAnalysisRow() {
        settingsLabel.text = purchased ? "Unlocked" : "Unavailable - Unlock PRO Pack"
    }
    
    

}
