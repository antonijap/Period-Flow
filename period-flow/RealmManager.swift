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
    func createPeriodObject(startDate: NSDate) {
        let period = Period()
        period.periodDates = [startDate]
        
        do {
            try realm.write {
                realm.add(period)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // Delete period object
    func deletePeriodObject(period: Period) {
        do {
            try realm.write {
                realm.delete(period)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // Update Period dates
    
    func updatePeriodDates(date: NSDate) {
//        do {
//            
//        } catch let error as NSError {
//            print(error.debugDescription)
//        }
    }
}
