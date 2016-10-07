//
//  RealmManager.swift
//  period-flow
//
//  Created by Steven on 5/31/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class RealmManager {
    
    enum Order {
        case ascendingStart
        case ascendingEnd
        case descendingStart
        case descendingEnd
    }
    
    // MARK: - Singleton
    
    static var sharedInstance = RealmManager()
    fileprivate init() {}
    
    // MARK: - Properties
    
    let realm = try! Realm()
    var today = DateInRegion().absoluteDate
    
    // MARK: - Methods
    
    // MARK: Querying objects in Realm
    
    /// Querys all the period objects in realm with no sorting
    func queryAllPeriods() -> [Period]? {
        return Array(realm.objects(Period.self))
    }
    
    /// Query all period objects in realm database
    func queryAllPeriods(_ order: Order) -> [Period]? {
        let periods = Array(realm.objects(Period.self))
        switch order {
        case .ascendingStart:
            return periods.sorted() {$0.startDate < $1.startDate}
        case .descendingStart:
            return periods.sorted() {$0.startDate! > $1.startDate!}
        case .ascendingEnd:
            return periods.sorted() {$0.endDate < $1.endDate}
        case .descendingEnd:
            return periods.sorted() {$0.endDate! > $1.endDate!}
        }
    }
    
    /// Query last period in realm
    func queryLastPeriod() -> Period? {
        let periods = queryAllPeriods(.descendingEnd)
        return periods?.first
    }
    
    /// Query the number of periods based on the analysis number
    func queryPeriodsForAnalysis() -> [Period]? {
        let analysisBasis = DefaultsManager.getAnalysisNumber()
        guard let periods = queryAllPeriods(.descendingStart) else {return nil}
        if periods.count <= 0 {
            return nil
        } else {
            let endIndex = periods.count - 1
            let startIndex = periods.count - analysisBasis < 0 ? 0 : periods.count - analysisBasis
            let result = periods[startIndex...endIndex]
            return Array(result)
        }
    }
    
    /// Get period object that contains specific date
    func periodThatContains(_ date: Date) -> Period? {
        guard let data = queryAllPeriods() else { return nil }

        for period in data {
            if period.assumedDates.contains(date) { return period }
        }
        return nil
    }
    
    /// Returns period object with closest start date to specified date
    func getPeriodForClosestStart(_ date: Date) -> Period? {
        
        var daysBetween: Int?
        var resultingPeriod: Period?
        
        if let periods = queryAllPeriods() {
            for period in periods {
                let value = abs(daysBetweenDate(date, endDate: period.startDate! as Date))
                if value < daysBetween || daysBetween == nil {
                    daysBetween = value
                    resultingPeriod = period
                }
            }
        }
        return resultingPeriod
    }
    
    /// Gets period object closest to the specified date
    func getClosestPeriodObject(_ date: Date) -> Period? {
        guard let closestStartPeriod = getPeriodForClosestStart(date), let closestEndPeriod = getPeriodForClosestEnd(date) else {
            return nil
        }
        
        let daysBetweenEndPeriod = abs(daysBetweenDate(closestEndPeriod.endDate! as Date, endDate: date))
        let daysBetweenStartPeriod = abs(daysBetweenDate(closestStartPeriod.startDate! as Date, endDate: date))
        
        return daysBetweenStartPeriod > daysBetweenEndPeriod ? closestEndPeriod : closestStartPeriod
    }
    
    /// Returns period object with closest end date to specified date
    func getPeriodForClosestEnd(_ date: Date) -> Period? {
        
        var daysBetween: Int?
        var resultingPeriod: Period?
        if let periods = queryAllPeriods() {
            for period in periods {
                let value = abs(daysBetweenDate(date, endDate: period.endDate! as Date))
                if value < daysBetween || daysBetween == nil {
                    daysBetween = value
                    resultingPeriod = period
                }
            }
        }
        return resultingPeriod
    }
    
    // MARK: Updating Objects in Realm
    
    /// Add period to Realm
    func addPeriod(_ period: Period) {
        do {
            try realm.write {
                realm.add(period)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    /// Update start date in realm
    func updateStartDate(_ period: Period, date: Date) {
        do {
            try realm.write {
                period.startDate = date
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    /// Update end date of period object in realm
    func updateEndDate(_ period: Period, date: Date) {
        do {
            try realm.write {
                period.endDate = date
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    /// Deletes period object from Realm
    func deletePeriod(_ period: Period) {
        do {
            try realm.write {
                realm.delete(period)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // MARK: Determining whether to update, create, or delete objects
    
    /// Updates or deletes the period object based on date
    func updateOrDeleteObject(_ date: Date) {
        guard let period = periodThatContains(date) else {
            return
        }
        if period.startDate! == period.endDate! && date == period.startDate {
            deletePeriod(period)
        } else {
            updatePeriodObjectDeselect(period, date: date)
        }
    }
    
    /// Determines whether to update object or to create new one
    func updateOrBeginNewObject(_ date: Date) {
        if let period = getClosestPeriodObject(date) {
            let days = daysBetweenDate(period.endDate! as Date, endDate: date)
            if days > 9 {
                createPeriod(date)
            } else {
                updatePeriodObjectSelect(period, date: date)
            }
        } else {
            createPeriod(date)
        }
    }
    
    /// Determines whether to update start date or end date of deselected period
    func updateStartDate(_ start1: Date, end1: Date, start2: Date, end2: Date) -> Bool {
        let value1 = abs(daysBetweenDate(start1, endDate: end1))
        let value2 = abs(daysBetweenDate(start2, endDate: end2))
        return value1 < value2
    }

    // MARK: Determining how to update an object
    
    /// Determines whether it should update the start or end date of period object with new date when cell selected
    func updatePeriodObjectSelect(_ period: Period, date: Date) {
        
        switch date.compare(period.startDate! as Date) {
            case .orderedAscending: updateStartDate(period, date: date)
            case .orderedDescending: break
            case .orderedSame: break
        }
        
        switch date.compare(period.endDate! as Date) {
            case .orderedAscending: break
            case .orderedDescending: updateEndDate(period, date: date)
            case .orderedSame: break
        }
    }
    
    /// Determines whether it should update the start or end date of period object with new date when cell is deselected
    func updatePeriodObjectDeselect(_ period: Period, date: Date) {
        if updateStartDate(period.startDate! as Date, end1: date, start2: period.endDate! as Date, end2: date) {
                switch date.compare(period.startDate! as Date) {
                case .orderedAscending: break
                case .orderedDescending: updateStartDate(period, date: date + 1.days)
                case .orderedSame: updateStartDate(period, date: date + 1.days)
            }
        } else {
            switch date.compare(period.endDate! as Date) {
                case .orderedAscending: updateEndDate(period, date: date - 1.days)
                case .orderedDescending: break
                case .orderedSame: updateEndDate(period, date: date - 1.days)
            }
        }
    }
    
    // MARK: - Creating new period objects
    
    /// Creates new period object from date and add to Realm
    func createPeriod(_ date: Date) {
        let period = Period()
        period.startDate = date
        period.endDate = date
        addPeriod(period)
    }

    // MARK: - Helper Methods
    
    /// Gets number of days between two NSDates as Int value
    func daysBetweenDate(_ startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        let components = (calendar as NSCalendar).components([.day], from: start, to: end, options: [])
        return components.day!
    }
    
    /// Calculates days until next period
    func daysUntilNextPeriod() -> Int? {
        guard let lastPeriod = queryLastPeriod(), let predictionDate = lastPeriod.predictionDate else {
            return nil
        }
        let days = daysBetweenDate(predictionDate as Date, endDate: today)
        return abs(days)
    }
}
