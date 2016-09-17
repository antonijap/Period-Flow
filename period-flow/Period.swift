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
    
    dynamic var startDate: Date?
    dynamic var endDate: Date?
    
    // Populates an array of dates in between start and end date of object
    var assumedDates: [Date] {
        
        var dates = [Date]()
        
        if let startDate = self.startDate, let endDate = self.endDate {
            
            if startDate == endDate {
                dates.append(startDate)
            } else {
                var nextDate = startDate
                dates.append(startDate)
                repeat {
                    nextDate = nextDate + 1.days
                    dates.append(nextDate)
                } while nextDate < endDate
            }
        }
        return dates
    }
    
    var predictionDate: Date? {
        
        guard let startDate = self.startDate else {
            return nil
        }
        
        let cycleDays = DefaultsManager.getCycleDays()
        let futureDate = startDate + (cycleDays.days - 1.days)
        return futureDate
    }
}
