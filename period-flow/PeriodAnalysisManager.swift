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
    
    class func getAveragePeriodDuration() -> Double? {
        guard let periods = RealmManager.sharedInstance.queryPeriodsForAnalysis() else {
            return nil
        }
        let totalDays = periods.reduce(0) { (total, period) in
            total + period.assumedDates.count
        }
        return Double(totalDays) / Double(DefaultsManager.getAnalysisNumber())
    }
    
    class func getAverageCycleDuration() -> Double? {
        guard let periods = RealmManager.sharedInstance.queryPeriodsForAnalysis() else {
            return nil
        }
        let totalDays = periods.reduce(0) { (total, period) in
            let daysBetween = daysBetweenDate(period.startDate!, endDate: period.endDate!)
            return total + abs(daysBetween)
        }
        return Double(totalDays) / Double(DefaultsManager.getAnalysisNumber())
    }
    
    // MARK: - Helper Methods
    
    /// Gets number of days between two NSDates as Int value
    private class func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.startOfDayForDate(startDate)
        let end = calendar.startOfDayForDate(endDate)
        let components = calendar.components([.Day], fromDate: start, toDate: end, options: [])
        return components.day
    }
}