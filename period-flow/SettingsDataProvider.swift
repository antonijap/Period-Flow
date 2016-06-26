//
//  SettingsDataProvider.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class SettingsDataProvider: NSObject {
    
    // MARK: - Properties
    
    var tableView: UITableView
    
    // MARK: - Initializers
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
}

extension SettingsDataProvider: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 4 ? 2 : 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "CYCLE DURATION IN DAYS"
        case 1: return "PURCHASES"
        case 2: return "NOTIFY ME"
        case 3: return "BASE YOUR ANALYSIS ON"
        default: return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as? SettingsCell ?? SettingsCell()
        cell.configureForSection(indexPath.section)
        return cell
    }
}
