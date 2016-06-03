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
}
