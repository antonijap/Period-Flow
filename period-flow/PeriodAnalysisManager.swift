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
    
    /// Gets the average period duration
    class func getAveragePeriodDuration() -> Double? {
        guard let periods = RealmManager.sharedInstance.queryPeriodsForAnalysis() else {
            return nil
        }
        let totalDays = periods.reduce(0) { (total, period) in
            total + period.assumedDates.count
        }
        return Double(totalDays) / Double(DefaultsManager.getAnalysisNumber())
    }
    
    /// Gets the average duration of the cycle
    class func getAverageCycleDuration() -> Double? {
        guard let periods = RealmManager.sharedInstance.queryPeriodsForAnalysis() else { return nil }
        
        var startDates = [NSDate]()
        periods.forEach { startDates.append($0.startDate!) }
        
        var endDates = [NSDate]()
        periods.forEach { endDates.append($0.endDate!) }
        
        var daysBetweenToAverage = [Int]()
        
        switch startDates.count {
        case 0:
            return 0
        case 1:
            return Double(DefaultsManager.getCycleDays())
        default:
            for n in 0..<startDates.count {
                
                if n == startDates.count - 1 { break }
                
                let daysBetween = abs(daysBetweenDate(startDates[n], endDate: startDates[n+1]))
                daysBetweenToAverage.append(daysBetween)
            }
            return daysBetweenToAverage.average + 1
        }
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