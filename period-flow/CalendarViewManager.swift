//
//  CalendarViewManager.swift
//  period-flow
//
//  Created by Steven on 5/31/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftDate


protocol CalendarViewManagerDelegate {
    var calendarView: JTAppleCalendarView! {get set}
    var yearLabel: UILabel! {get set}
    var monthNameLabel: UILabel! {get set}
}

class CalendarViewManager: NSObject {
    
    // MARK: - Properties
    
    var calendarView: JTAppleCalendarView!
    var delegate: CalendarViewManagerDelegate?
    var selectedDates = [NSDate]()
    
    // MARK: - Initializers
    
    init(calendarView: JTAppleCalendarView) {
        self.calendarView = calendarView
    }
    
}

extension CalendarViewManager: JTAppleCalendarViewDelegate {
    
    // Rendering all dates, reloadCalendar() reloads .ThisMonth
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        let cell = cell as! CellView
        cell.setupCellBeforeDisplay(cellState, date: date)
        
        if cellState.dateBelongsTo == .ThisMonth {
            cell.userInteractionEnabled = true
        } else {
            cell.userInteractionEnabled = false
        }
        
        //print("Date: \(date.toString(DateFormat.Custom("dd.MM.YYYY."))!) and cellState is: \(cellState)")
    }
    
    // User selects a date
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let cell = cell as! CellView
        
        cell.cellSelectionChanged(cellState, date: date)
        
        RealmManager.sharedInstance.updateOrBeginNewObject(date)
        updateCalendarUI()
    }
    
    // User deselects a date
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let cell = cell as! CellView
        
        cell.cellSelectionChanged(cellState, date: date)
        
        RealmManager.sharedInstance.updateOrDeleteObject(date)
        updateCalendarUI()
    }
    
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        delegate?.monthNameLabel.text = startDate.monthName
        delegate?.yearLabel.text = String(startDate.year)
    }
    
    // Get all dates from period and display them
    func displayAllDates() {
        
        let periods = RealmManager.sharedInstance.queryAllPeriods()!
        
        for period in periods {
            selectedDates = selectedDates + period.assumedDates
            print("Assumed dates are: \(period.assumedDates)")
        }
        
        calendarView.selectDates(selectedDates, triggerSelectionDelegate: false)
    }
    
    func updateCalendarUI() {
        selectedDates = [] // Empty selected dates
        let alreadySelectedDates = calendarView.selectedDates
        calendarView.selectDates(alreadySelectedDates, triggerSelectionDelegate: false)

        let periods = RealmManager.sharedInstance.queryAllPeriods()!
        print(periods)
        
        for period in periods {
            selectedDates = selectedDates + period.assumedDates // Populate them again with new updated values
            print("Assumed dates are: \(period.assumedDates)")
        }
        
        calendarView.selectDates(selectedDates, triggerSelectionDelegate: true) // Display Dates
        calendarView.reloadData() // reload Calendar
        
    }
}
