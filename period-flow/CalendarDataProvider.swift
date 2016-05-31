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
    var monthName: String!
    var year: String!
    
    // MARK: - Initializers
    
    init(calendarView: JTAppleCalendarView) {
        self.calendarView = calendarView
        super.init()
    }
}

extension CalendarDataProvider: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate  {
    
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
        
        if cellState.dateBelongsTo == .ThisMonth {
            cell.userInteractionEnabled = true
        } else {
            cell.userInteractionEnabled = false
        }
        
        print("Date: \(date.toString(DateFormat.Custom("dd.MM.YYYY."))!) and cellState is: \(cellState)")
    }
    
    // User deselects a date
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        let cell = (cell as! CellView)
        cell.cellSelectionChanged(cellState)
    }
    
    // User selects a date
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        let cell = (cell as! CellView)
        cell.cellSelectionChanged(cellState)
    }
    
    // User scrolls to another month
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWith date: NSDate?, endingWithDate: NSDate?) {
        if let _ = date, _ = endingWithDate {
            if let date = date {
                let monthName = date.monthName
                let year = String(date.year)
                self.monthName = monthName
                self.year = String(year)
            }
        }
    }
}
