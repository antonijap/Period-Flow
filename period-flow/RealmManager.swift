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

class RealmManager {
    
    // MARK: - Singleton
    
    static var sharedInstance = RealmManager()
    private init() {}
    
    // MARK: - Properties
    
    let realm = try! Realm()
    var today = NSDate.today()
    
    // MARK: - Methods
    
    // MARK: Querying objects in Realm
    
    /// Query all period objects in realm database
    func queryAllPeriods() -> Results<Period>? {
        return realm.objects(Period)
    }
    
    /// Query last period object in realm
    func queryLastPeriod() -> Period? {
        return realm.objects(Period).first
    }
    
    /// Query the number of periods based on the analysis number
    func queryPeriodsForAnalysis() -> Slice<Results<Period>>? {
        let analysisBasis = DefaultsManager.getAnalysisNumber()
        let periods = realm.objects(Period)
        if periods.count < 0 {
            return nil
        } else {
            let endIndex = periods.count - 1
            let startIndex = periods.count - analysisBasis
            return periods[startIndex...endIndex]
        }
        
        
        // if there are 5 objects...
        // we want last 3
        // index s = 2
        // index e = 4
        
        // if there are 5 objs...
        // we want last 4
        // index s = 1
        // index e = 4
        
        // if there are 0 objs
        // we want last 1
        // index doesnt exist
        
        // if there are 1 objs
        // we want last 1
        // index s = 0
        // index e = 0
        
        // if there are 2 objs
        // we want last 1
        // index s = 1
        // index e = 1
        
        // if there are 3 objs
        // we want last 2
        // index s = 1
        // index e = 2
    }
    
    /// Get period object that contains specific date
    func periodThatContains(date: NSDate) -> Period? {
        
        let results = queryAllPeriods()
        guard let data = results else {
            return nil
        }
        
        for period in data {
            if period.assumedDates.contains(date) {
                return period
            }
        }
        return nil
    }
    
    /// Returns period object with closest start date to specified date
    func getPeriodForClosestStart(date: NSDate) -> Period? {
        
        var daysBetween: Int?
        var resultingPeriod: Period?
        
        if let periods = queryAllPeriods() {
            for period in periods {
                let value = abs(daysBetweenDate(date, endDate: period.startDate!))
                if value < daysBetween || daysBetween == nil {
                    daysBetween = value
                    resultingPeriod = period
                }
            }
        }
        return resultingPeriod
    }
    
    /// Gets period object closest to the specified date
    func getClosestPeriodObject(date: NSDate) -> Period? {
        guard let closestStartPeriod = getPeriodForClosestStart(date), let closestEndPeriod = getPeriodForClosestEnd(date) else {
            return nil
        }
        
        let daysBetweenEndPeriod = abs(daysBetweenDate(closestEndPeriod.endDate!, endDate: date))
        let daysBetweenStartPeriod = abs(daysBetweenDate(closestStartPeriod.startDate!, endDate: date))
        
        return daysBetweenStartPeriod > daysBetweenEndPeriod ? closestEndPeriod : closestStartPeriod
    }
    
    /// Returns period object with closest end date to specified date
    func getPeriodForClosestEnd(date: NSDate) -> Period? {
        
        var daysBetween: Int?
        var resultingPeriod: Period?
        if let periods = queryAllPeriods() {
            for period in periods {
                let value = abs(daysBetweenDate(date, endDate: period.endDate!))
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
    func addPeriod(period: Period) {
        do {
            try realm.write {
                realm.add(period)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    /// Update start date in realm
    func updateStartDate(period: Period, date: NSDate) {
        do {
            try realm.write {
                period.startDate = date
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    /// Update end date of period object in realm
    func updateEndDate(period: Period, date: NSDate) {
        do {
            try realm.write {
                period.endDate = date
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    /// Deletes period object from Realm
    func deletePeriod(period: Period) {
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
    func updateOrDeleteObject(date: NSDate) {
        guard let period = periodThatContains(date) else {
            return
        }
        if period.startDate == period.endDate && date == period.startDate {
            deletePeriod(period)
        } else {
            updatePeriodObjectDeselect(period, date: date)
        }
    }
    
    /// Determines whether to update object or to create new one
    func updateOrBeginNewObject(date: NSDate) {
        if let period = getClosestPeriodObject(date) {
            let days = daysBetweenDate(period.endDate!, endDate: date)
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
    func updateStartDate(start1: NSDate, end1: NSDate, start2: NSDate, end2: NSDate) -> Bool {
        let value1 = abs(daysBetweenDate(start1, endDate: end1))
        let value2 = abs(daysBetweenDate(start2, endDate: end2))
        return value1 < value2
    }

    // MARK: Determining how to update an object
    
    /// Determines whether it should update the start or end date of period object with new date when cell selected
    func updatePeriodObjectSelect(period: Period, date: NSDate) {
        
        switch date.compare(period.startDate!) {
            case .OrderedAscending: updateStartDate(period, date: date)
            case .OrderedDescending: break
            case .OrderedSame: break
        }
        
        switch date.compare(period.endDate!) {
            case .OrderedAscending: break
            case .OrderedDescending: updateEndDate(period, date: date)
            case .OrderedSame: break
        }
    }
    
    /// Determines whether it should update the start or end date of period object with new date when cell is deselected
    func updatePeriodObjectDeselect(period: Period, date: NSDate) {
        if updateStartDate(period.startDate!, end1: date, start2: period.endDate!, end2: date) {
                switch date.compare(period.startDate!) {
                case .OrderedAscending: break
                case .OrderedDescending: updateStartDate(period, date: date + 1.days)
                case .OrderedSame: updateStartDate(period, date: date + 1.days)
            }
        } else {
            switch date.compare(period.endDate!) {
                case .OrderedAscending: updateEndDate(period, date: date - 1.days)
                case .OrderedDescending: break
                case .OrderedSame: updateEndDate(period, date: date - 1.days)
            }
        }
    }
    
    // MARK: - Creating new period objects
    
    /// Creates new period object from date and add to Realm
    func createPeriod(date: NSDate) {
        let period = Period()
        period.startDate = date
        period.endDate = date
        addPeriod(period)
    }

    // MARK: - Helper Methods
    
    /// Gets number of days between two NSDates as Int value
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.startOfDayForDate(startDate)
        let end = calendar.startOfDayForDate(endDate)
        let components = calendar.components([.Day], fromDate: start, toDate: end, options: [])
        return components.day
    }
    
    /// Calculates days until next period
    func daysUntilNextPeriod() -> Int? {
        guard let lastPeriod = queryLastPeriod(), let predictionDate = lastPeriod.predictionDate else {
            return nil
        }
        let days = daysBetweenDate(predictionDate, endDate: today)
        return abs(days)
    }
}
