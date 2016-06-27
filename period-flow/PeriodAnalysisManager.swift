//
//  PeriodAnalysisManager.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation
import RealmSwift

class PeriodAnalysisManager {
    
    // MARK: - Methods
    
    class func performAnalysis(operation: (Slice<Results<Period>>, Int) -> Double) -> Double? {
        guard let periods = RealmManager.sharedInstance.queryAllPeriods() else {
            return nil
        }
        let durationBasis = DefaultsManager.getAnalysisNumber()
        let endIndex = periods.endIndex
        let startIndex = periods.count - durationBasis
        
        return operation(periods[startIndex...endIndex], durationBasis)
        
    }
    
    class func averagePeriodDuration(periods: Slice<Results<Period>>, durationBasis: Int) -> Double {
        let totalDays = periods.reduce(0) { (total, period) in
            return period.assumedDates.count + 2
        }
        return Double(totalDays / durationBasis)
    }
    
    
    class func getAverageCycleDuration(periods: Slice<Results<Period>>, durationBasis: Int) -> Double {
        let totalDays = periods.reduce(0) { (total, period) in
            let daysBetween = RealmManager.sharedInstance.daysBetweenDate(period.startDate!, endDate: period.endDate!)
            return abs(daysBetween)
        }
        return Double(totalDays / durationBasis)
    }
}