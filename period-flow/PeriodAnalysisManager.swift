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
        guard let periods = RealmManager.sharedInstance.queryAllPeriods() else {
            return nil
        }
        var arrayOfStartDates: [NSDate] = []

        for period in periods {
            arrayOfStartDates.append(period.startDate!)
        }
        print("Array of start dates hold: \(arrayOfStartDates)")
        
        var arrayOfDaysBetweenPeriods = [Int]()
        var indexValue = 0
        
        if arrayOfStartDates.count == 1 {
            return Double(DefaultsManager.getCycleDays())
        } else {
            while indexValue < arrayOfStartDates.count - 1 {
                let daysBetween = daysBetweenDate(arrayOfStartDates[indexValue], endDate: arrayOfStartDates[indexValue + 1])
                arrayOfDaysBetweenPeriods.append(daysBetween)
                indexValue += 1
            }
        }
        print("Array of days between Periods hold: \(arrayOfDaysBetweenPeriods)")

        return arrayOfDaysBetweenPeriods.average + 1
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