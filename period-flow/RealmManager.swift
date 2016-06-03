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
    
    func queryAllPeriods() -> Results<Period> {
        return realm.objects(Period)
    }
    
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        return components.day
    }
    
    func getPeriodForClosestStart(date: NSDate) -> Period {
        
        var daysBetween: Int?
        var resultingPeriod = Period()
        
        for period in queryAllPeriods() {
            let value = abs(daysBetweenDate(date, endDate: period.startDate!))
            if value < daysBetween || daysBetween == nil {
                daysBetween = value
                resultingPeriod = period
            }
        }
        return resultingPeriod
    }
    
    func getPeriodForClosestEnd(date: NSDate) -> Period {
        
        var daysBetween: Int?
        var resultingPeriod = Period()
        
        for period in queryAllPeriods() {
            let value = abs(daysBetweenDate(date, endDate: period.endDate!))
            print(value)
            if value < daysBetween || daysBetween == nil {
                daysBetween = value
                resultingPeriod = period
            }
        }
        return resultingPeriod
    }
    
    func getClosestPeriodObject(date: NSDate) -> Period {
        let closestStartPeriod = getPeriodForClosestStart(date)
        let closestEndPeriod = getPeriodForClosestEnd(date)
        
        let daysBetweenEndPeriod = abs(daysBetweenDate(closestEndPeriod.endDate!, endDate: date))
        let daysBetweenStartPeriod = abs(daysBetweenDate(closestStartPeriod.startDate!, endDate: date))
        
        return daysBetweenStartPeriod > daysBetweenEndPeriod ? closestEndPeriod : closestStartPeriod
    }
    

}
