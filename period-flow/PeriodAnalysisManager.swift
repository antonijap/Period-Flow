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
    
    class func performAnalysis(operation: (Slice<Results<Period>>, Double) -> Double) -> Double? {
        guard let periods = RealmManager.sharedInstance.queryAllPeriods() where periods.count > 0 else {
            return nil
        }
        let durationBasis = DefaultsManager.getAnalysisNumber()
        let endIndex = periods.endIndex.predecessor()
        let startIndex = calculateStartIndex(periods, durationBasis: durationBasis)
        
        return operation(periods[startIndex...endIndex], Double(durationBasis))
        
    }
    
    class func calculateStartIndex(periods: Results<Period>, durationBasis: Int) -> Int {
        switch periods.count {
            case 1: return 0
            case 2: return durationBasis - 1
            default: return periods.count - durationBasis
        }
    }
    
    class func averagePeriodDuration(periods: Slice<Results<Period>>, durationBasis: Double) -> Double {
        let totalDays = periods.reduce(0) { (total, period) in
            return total + period.assumedDates.count
        }
        print(totalDays)
        return Double(totalDays) / durationBasis
    }
    
    
    class func getAverageCycleDuration(periods: Slice<Results<Period>>, durationBasis: Double) -> Double {
        let totalDays = periods.reduce(0) { (total, period) in
            let daysBetween = daysBetweenDate(period.startDate!, endDate: period.endDate!)
            return abs(daysBetween)
        }
        return Double(totalDays) / durationBasis
    }
    
    /// Gets number of days between two NSDates as Int value
    class func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.startOfDayForDate(startDate)
        let end = calendar.startOfDayForDate(endDate)
        let components = calendar.components([.Day], fromDate: start, toDate: end, options: [])
        return components.day
    }

}