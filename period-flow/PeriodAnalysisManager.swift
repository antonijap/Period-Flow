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
    
    // TODO: This function should determine how many days between first dates of all periods
    class func getAverageCycleDuration() -> Double? {
        guard let periods = RealmManager.sharedInstance.queryPeriodsForAnalysis() else {
            return nil
        }
        let totalDays = periods.reduce(0) { (total, period) in
            print(period.startDate!)
            print(period.predictionDate)
            let daysBetween = daysBetweenDate(period.predictionDate!, endDate: period.startDate!)
            return total + abs(daysBetween)
        }
        return Double(totalDays) / Double(DefaultsManager.getAnalysisNumber())
    }
    
    class func getAverageCycleDurationNew() -> Double? {
        guard let periods = RealmManager.sharedInstance.queryAllPeriods() else {
            return nil
        }
        
        var arrayOfStartDates: [NSDate] = []
        arrayOfStartDates.removeAll()
        for period in periods {
            arrayOfStartDates.append(period.startDate!)
        }
        print("Array of start dates hold: \(arrayOfStartDates)")
        
        var arrayOfDaysBetweenPeriods = [Int]()
        arrayOfDaysBetweenPeriods.removeAll()
        var indexValue = 0
        while indexValue < arrayOfStartDates.count - 1 {
            let daysBetween = daysBetweenDate(arrayOfStartDates[indexValue], endDate: arrayOfStartDates[indexValue + 1])
            print(daysBetween)
            arrayOfDaysBetweenPeriods.append(daysBetween)
            indexValue += 1
        }
        print("Array of days between Periods hold: \(arrayOfDaysBetweenPeriods)")

        return arrayOfDaysBetweenPeriods.average
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

extension Array where Element: IntegerType {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, combine: +)
    }
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(total.hashValue) / Double(count)
    }
}