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
    
    // This method is required. You provide a startDate, endDate, and a calendar configured to your liking.
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, calendar: NSCalendar) {
        let firstDate = 1.years.ago
        let secondDate = 1.years.fromNow
        let aCalendar = NSCalendar.currentCalendar() // Properly configure your calendar to your time zone here
        
        return (startDate: firstDate, endDate: secondDate, calendar: aCalendar)
    }

    
    // Rendering all dates
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        let cell = (cell as! CellView)
        cell.setupCellBeforeDisplay(cellState, date: date)
        
        
        // If date belongs to previous or future month, user can't select it until she scrolls to the appropriate month
        if cellState.dateBelongsTo == .ThisMonth {
            cell.userInteractionEnabled = true
        } else {
            cell.userInteractionEnabled = false
        }
        
//        print("Date: \(date.toString(DateFormat.Custom("dd.MM.YYYY."))!) and cellState is: \(cellState)")
    }
}
