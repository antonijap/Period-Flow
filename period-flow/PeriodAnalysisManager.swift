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
        
        var startDates = [Date]()
        periods.forEach { startDates.append($0.startDate! as Date) }
        
        var endDates = [Date]()
        periods.forEach { endDates.append($0.endDate! as Date) }
        
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
    fileprivate class func daysBetweenDate(_ startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        let components = (calendar as NSCalendar).components([.day], from: start, to: end, options: [])
        return components.day!
    }
}
