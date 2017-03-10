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

// MARK: - CalendarViewManagerDelegate

protocol CalendarViewManagerDelegate {
    var calendarView: JTAppleCalendarView! {get set}
    var yearLabel: UILabel! {get set}
    var monthNameLabel: UILabel! {get set}
    var daysUntilNextPeriodLabel: UILabel! {get set}
    var counterLabel: UILabel! {get set}
}

class CalendarViewManager: NSObject {
    
    // MARK: - Properties
    
    var calendarView: JTAppleCalendarView!
    var delegate: CalendarViewManagerDelegate?
    var selectedDates = [Date]()
    var today = Date()
    
    // MARK: - Initializers
    
    init(calendarView: JTAppleCalendarView) {
        self.calendarView = calendarView
    }
    
    // MARK: - Methods
    
    /// Get all dates from period and display them
    func displayAllDates() {
        let periods = RealmManager.sharedInstance.queryAllPeriods()!
        
        for period in periods {
            selectedDates = selectedDates + period.assumedDates
        }
        
        calendarView.selectDates(selectedDates, triggerSelectionDelegate: false)
        calendarView.reloadData()
    }
    
    /// Update UI when a date is selected
    func updateUIForSelection() {
        var datesToSelect = [Date]()
        let queryResults = RealmManager.sharedInstance.queryAllPeriods()
        if let periods = queryResults {
            for period in periods {
                datesToSelect += period.assumedDates.filter { date in
                    calendarView.selectedDates.contains(date as Date) != true
                }
            }
            calendarView.selectDates(datesToSelect, triggerSelectionDelegate: false)
            calendarView.reloadData()
        }
    }
    
    /// Update UI when a date is deselected
    func updateUIForDeselection() {
        var selectedDates = Set<Date>(calendarView.selectedDates)
        let queryResults = RealmManager.sharedInstance.queryAllPeriods()
        if let periods = queryResults {
            for period in periods {
                let assumedDates = Set<Date>(period.assumedDates)
                selectedDates.subtract(assumedDates)
            }
        }
        calendarView.selectDates([Date](selectedDates), triggerSelectionDelegate: false)
        calendarView.reloadData()
    }
    
    /// Displays future period on a Calendar
    func displayPredictionDate(_ cell: CellView, date: Date, cellState: CellState) {
        let period = RealmManager.sharedInstance.queryLastPeriod()
        if let period = period {
            if (period.predictionDate?.isInSameDayOf(date: date))! {
                cell.displayPrediction(true, cellState: cellState)
            } else {
                cell.displayPrediction(false, cellState: cellState)
            }
        }
    }
    
    /// Configures the period days counter
    func configureCounter() {
        let days = RealmManager.sharedInstance.daysUntilNextPeriod()
        // TODO: Make code which grabs latest period - this is the period which is closest to today's date
        let lastPeriod = RealmManager.sharedInstance.queryLastPeriod()

        if let predictionDate = lastPeriod?.predictionDate, let days = days {
            
            let daysOrDays = days == 1 ? "Day" : "Days"
            delegate?.daysUntilNextPeriodLabel.text = "\(days)"
            
            switch true {
                case today.isBefore(date: predictionDate, granularity: .day):
                    delegate?.counterLabel.text = "\(daysOrDays) Until Next Period"
                case today.isAfter(date: predictionDate, granularity: .day):
                    delegate?.counterLabel.text = "\(daysOrDays) Late"
                case today.isToday:
                    delegate?.counterLabel.text = "Period Starts Today"
                default: break
            }
        } else {
            delegate?.counterLabel.text = "Select A Date To Begin"
            delegate?.daysUntilNextPeriodLabel.text = "?"
        }
    }
}

// MARK: - JTAppleCalendarViewDelegate Conformance

extension CalendarViewManager: JTAppleCalendarViewDelegate {
    
    // Rendering all dates
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let cell = cell as! CellView
        cell.setupCellBeforeDisplay(cellState, date: date)
        if cellState.dateBelongsTo == .thisMonth {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }
        
        // Circle prediction date, default 28 days
        displayPredictionDate(cell, date: date, cellState: cellState)
    }
    
    // User selects a date
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let cell = cell as! CellView
        cell.cellSelectionChanged(cellState, date: date)
        
        RealmManager.sharedInstance.updateOrBeginNewObject(date)
        updateUIForSelection()
        
        configureCounter()
    }
    
    // User deselects a date
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let cell = cell as! CellView
        cell.cellSelectionChanged(cellState, date: date)
        
        RealmManager.sharedInstance.updateOrDeleteObject(date)
        updateUIForDeselection()
        
        configureCounter()
    }
    
    // Set month name label and year label
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.month,.day,.year], from: visibleDates.monthDates.first!)
        
        let monthName = calendar.monthSymbols[components.month! - 1]
        let year = components.year!
        
        delegate?.monthNameLabel.text = String(monthName)
        delegate?.yearLabel.text = String(year)
    }
}

