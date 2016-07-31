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
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        let firstDate = 1.years.ago
        let secondDate = 1.years.fromNow
        let aCalendar = NSCalendar.autoupdatingCurrentCalendar() // Properly configure your calendar to your time zone here
        let rows = 5
        
        return (startDate: firstDate, endDate: secondDate, numberOfRows: rows, calendar: aCalendar)
    }
}
