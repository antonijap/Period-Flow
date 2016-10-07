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
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> (startDate: Date, endDate: Date, numberOfRows: Int, calendar: Calendar) {
//        let firstDate = 1.years.ago()
//        let secondDate = 1.years.from(date: DateInRegion().absoluteDate)
//        let aCalendar = Calendar.autoupdatingCurrent // Properly configure your calendar to your time zone here
//        let rows = 5
//        print("Prvi datum je \(firstDate), drugi datum je \(secondDate)")
//        return (startDate: firstDate!, endDate: secondDate!, numberOfRows: rows, calendar: aCalendar)
//    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> (startDate: Date, endDate: Date, numberOfRows: Int, calendar: Calendar) {
        // You can set your date using NSDate() or NSDateFormatter. Your choice.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        // TODO:
        // Make firstDate and secondDate to be 40 years from today
        
        let firstDate = formatter.date(from: "2000 01 01")
        let secondDate = formatter.date(from: "2050 01 01")
        let numberOfRows = 6
        let aCalendar = Calendar.current // Properly configure your calendar to your time zone here
        
        return (startDate: firstDate!, endDate: secondDate!, numberOfRows: numberOfRows, calendar: aCalendar)
    }
}
