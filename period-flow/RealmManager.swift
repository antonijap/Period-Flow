//
//  RealmManager.swift
//  period-flow
//
//  Created by Steven on 5/31/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager {
    
    // MARK: - Singleton
    
    static var sharedInstance = RealmManager()
    private init() {}
    
    // MARK: - Properties
    
    let realm = try! Realm()
    
    // MARK: - Methods
    
    // Create new period object from date
    
    func createPeriodObject(date: NSDate) {
        let period = Period()
        period.startDate = date
        period.endDate = date
        
        do {
            try realm.write {
                realm.add(period)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // Query all period objects in realm
    
    func queryAllPeriods() -> Results<Period>? {
        return realm.objects(Period)
    }
    
    // Get days between two NSDates as Int
    
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        return components.day
    }
    
    // Get period object with closest start date to date
    
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
    
    // Get period object with closest end date to date
    
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
    
    // Get closest period object

    func getClosestPeriodObject(date: NSDate) -> Period? {
        guard let closestStartPeriod = getPeriodForClosestStart(date), let closestEndPeriod = getPeriodForClosestEnd(date) else {
            return nil
        }
        
        let daysBetweenEndPeriod = abs(daysBetweenDate(closestEndPeriod.endDate!, endDate: date))
        let daysBetweenStartPeriod = abs(daysBetweenDate(closestStartPeriod.startDate!, endDate: date))
        
        return daysBetweenStartPeriod > daysBetweenEndPeriod ? closestEndPeriod : closestStartPeriod
    }
    
    // Determine whether or not to update object or create a new one
    
    func updateOrBeginNewObject(date: NSDate) {
        if let period = getClosestPeriodObject(date) {
            let days = daysBetweenDate(period.endDate!, endDate: date)
            if days > 3 {
                createPeriodObject(date)
            } else {
                updatePeriodObject(period, date: date)
            }
        } else {
            createPeriodObject(date)
        }
    }
    
    // Update period object
    
    func updatePeriodObject(period: Period, date: NSDate) {
        switch date.compare(period.startDate!) {
            case .OrderedAscending:
                do {
                    try realm.write {
                        period.startDate = date
                    }
                } catch let error as NSError {
                    print(error.debugDescription)
                }
            case .OrderedDescending: break
            case .OrderedSame: break
        }
        
        switch date.compare(period.endDate!) {
            case .OrderedAscending: break
            case .OrderedDescending:
                do {
                    try realm.write {
                        period.endDate = date
                    }
                } catch let error as NSError {
                    print(error.debugDescription)
            }
            case .OrderedSame: break
        }
    }
}
