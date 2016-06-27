//
//  AnalysisCell.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class AnalysisCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var avgPeriodDuration: UILabel!
    @IBOutlet weak var avgCycleDuration: UILabel!
    
    // MARK: - Methods
    
    func configureCell() {
        if let avgPeriod = PeriodAnalysisManager.performAnalysis(PeriodAnalysisManager.averagePeriodDuration) {
            avgPeriodDuration.text = "\(avgPeriod)"
        }
        
        if let avgCycle = PeriodAnalysisManager.performAnalysis(PeriodAnalysisManager.getAverageCycleDuration) {
            avgCycleDuration.text = "\(avgCycle)"
        }
    }
}
