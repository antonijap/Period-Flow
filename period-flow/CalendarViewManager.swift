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
    var averageCycleDaysLabel: UILabel! {get set}
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
            print("Assumed dates are: \(period.assumedDates)")
        }
        calendarView.selectDates(selectedDates, triggerSelectionDelegate: false)
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
                selectedDates.subtractInPlace(period.assumedDates)
                
            }
        }
        calendarView.selectDates([Date](selectedDates), triggerSelectionDelegate: false)
        calendarView.reloadData()
    }
    
    /// Displays future period on a Calendar
    func displayPredictionDate(_ cell: CellView, date: Date, cellState: CellState) {
        let period = RealmManager.sharedInstance.queryLastPeriod()
        if let period = period {
            if period.predictionDate!.isInSameDayAsDate(date: date) {
                cell.displayPrediction(true, cellState: cellState)
            } else {
                cell.displayPrediction(false, cellState: cellState)
            }
        }
    }
    
    /// Update cycleDays label
    func updateUIforCycleDays() {
        delegate?.averageCycleDaysLabel.text = "\(DefaultsManager.getCycleDays())"
        if let days = RealmManager.sharedInstance.daysUntilNextPeriod() {
            delegate?.daysUntilNextPeriodLabel.text = "\(days)"
        }
        calendarView.reloadData()
    }
    
    /// Configures the period days counter
    func configureCounter() {
        let days = RealmManager.sharedInstance.daysUntilNextPeriod()
        // TODO: Make code which grabs latest period - this is the period which is closest to today's date
        let lastPeriod = RealmManager.sharedInstance.queryLastPeriod()

        if let predictionDate = lastPeriod?.predictionDate, let days = days {
            
            let daysOrDays = days == 1 ? "DAY" : "DAYS"
            delegate?.daysUntilNextPeriodLabel.text = "\(days)"
            
            switch true {
                case today.isBefore(component: .day, ofDate: predictionDate):
                    delegate?.counterLabel.text = "\(daysOrDays) UNTIL \nNEXT PERIOD"
                case today.isAfter(component: .day, ofDate: predictionDate):
                    delegate?.counterLabel.text = "\(daysOrDays) \nLATE"
                case today.isInToday():
                    delegate?.counterLabel.text = "PERIOD STARTS \nTODAY"
                default: break
            }
        } else {
            delegate?.counterLabel.text = "SELECT A DATE \nTO BEGIN"
            delegate?.daysUntilNextPeriodLabel.text = "?"
        }
    }
}

// MARK: - JTAppleCalendarViewDelegate Conformance

extension CalendarViewManager: JTAppleCalendarViewDelegate {
    
    // Rendering all dates, reloadCalendar() reloads .ThisMonth
    func calendar(_ calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let cell = cell as! CellView
        cell.setupCellBeforeDisplay(cellState, date: (date as NSDate) as Date)
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
        cell.cellSelectionChanged(cellState, date: date as NSDate)
        
        RealmManager.sharedInstance.updateOrBeginNewObject(date)
        updateUIForSelection()
        
        configureCounter()
    }
    
    // User deselects a date
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let cell = cell as! CellView
        cell.cellSelectionChanged(cellState, date: date as NSDate as NSDate)
        
        RealmManager.sharedInstance.updateOrDeleteObject(date)
        updateUIForDeselection()
        
        configureCounter()
        
    }
    
    // Set month name label and year label
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: Date, endingWithDate endDate: Date) {
        delegate?.monthNameLabel.text = startDate.monthName
        delegate?.yearLabel.text = String(startDate.year)
    }
}
