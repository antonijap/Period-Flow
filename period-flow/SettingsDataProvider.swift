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
    
    // MARK: - Methods
}

extension SettingsDataProvider: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as? SettingsCell ?? SettingsCell()
        settingCell.configureForSection(indexPath.section)
        
        let analysisCell = tableView.dequeueReusableCellWithIdentifier("AnalysisCell") as? AnalysisCell ?? AnalysisCell()
        return indexPath.section == 4 ? analysisCell : settingCell
    }
}
