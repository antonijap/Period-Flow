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
    var assumedDates: [NSDate] {
        var dates = [NSDate]()
        if let startDate = self.startDate, let endDate = self.endDate {
            var date = startDate
            dates.append(startDate)
            while date < endDate {
                date = date + 1.days
                dates.append(date)
            }
            dates.append(endDate)
            print(dates)
            return dates
        }
        return [NSDate]()
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
}
