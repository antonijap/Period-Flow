//
//  CalendarDataProvider.swift
//  period-flow
//
//  Created by Steven on 5/31/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftDate

class CalendarDataProvider: NSObject {
    
    // MARK: - Properties
    
    var calendarView: JTAppleCalendarView!
    
    // MARK: - Initializers
    
    init(calendarView: JTAppleCalendarView) {
        self.calendarView = calendarView
        super.init()
    }
}

extension CalendarDataProvider: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2010 01 10")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2020 01 01")!   // You can also use dates created from this function
        
//        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
}
