//
//  CalendarDataProvider.swift
//  period-flow
//
//  Created by Steven on 5/31/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import JTAppleCalendarView

class CalendarDataProvider: NSObject {
    
    // MARK: - Properties
    
    var calendarView: JTAppleCalendarView!
    
    // MARK: - Initializers
    
    init(calendarView: JTAppleCalendarView) {
        self.calendarView = calendarView
        super.init()
    }
}

extension CalendarDataProvider: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate  {
    // Setting up manditory protocol method
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, calendar: NSCalendar) {
        let firstDate = "1/1/2016".toDate(DateFormat.Custom("dd/MM/YYYY"))
        let secondDate = NSDate()
        let aCalendar = NSCalendar.currentCalendar() // Properly configure your calendar to your time zone here
        return (startDate: firstDate!, endDate: secondDate, calendar: aCalendar)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        (cell as! CellView).setupCellBeforeDisplay(cellState, date: date)
    }
}
