//
//  Period.swift
//  period-flow
//
//  Created by Steven on 6/2/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate

class Period: Object {
    
    // MARK: - Properties
    
    dynamic var startDate: NSDate?
    dynamic var endDate: NSDate?
    
    // Populates an array of dates in between start and end date of object
    var assumedDates: [NSDate] {
        
        var dates = [NSDate]()
        
        if let startDate = self.startDate, let endDate = self.endDate {
            
            if startDate == endDate {
                dates.append(startDate)
            } else {
                var nextDate = startDate
                
                repeat {
                    nextDate = nextDate + 1.days
                    dates.append(nextDate)
                } while nextDate < endDate
            }
        }
        return dates
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
}
