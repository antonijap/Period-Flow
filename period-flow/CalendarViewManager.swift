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
    var selectedDates = [NSDate]()
    var today = NSDate()
    
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
        var datesToSelect = [NSDate]()
        let queryResults = RealmManager.sharedInstance.queryAllPeriods()
        if let periods = queryResults {
            for period in periods {
                datesToSelect += period.assumedDates.filter { date in
                    calendarView.selectedDates.contains(date) != true
                }
            }
            calendarView.selectDates(datesToSelect, triggerSelectionDelegate: false)
            calendarView.reloadData()
        }
    }
    
    /// Update UI when a date is deselected
    func updateUIForDeselection() {
        var selectedDates = Set<NSDate>(calendarView.selectedDates)
        let queryResults = RealmManager.sharedInstance.queryAllPeriods()
        if let periods = queryResults {
            for period in periods {
                selectedDates.subtractInPlace(period.assumedDates)
                
            }
        }
        calendarView.selectDates([NSDate](selectedDates), triggerSelectionDelegate: false)
        calendarView.reloadData()
    }
    
    /// Displays future period on a Calendar
    func displayPredictionDate(cell: CellView, date: NSDate, cellState: CellState) {
        let period = RealmManager.sharedInstance.queryAllPeriods()?.last
        if let period = period {
            if period.predictionDate!.isInSameDayAsDate(date) {
                cell.displayPrediction(true, cellState: cellState)
            } else {
                cell.displayPrediction(false, cellState: cellState)
            }
        }
    }
    
    /// Update cycleDays label
    func updateUIforCycleDays() {
        delegate?.averageCycleDaysLabel.text = "\(DefaultsManager.getCycleDays())"
        delegate?.daysUntilNextPeriodLabel.text = "\(RealmManager.sharedInstance.daysUntilNextPeriod())"
        calendarView.reloadData()
    }
    
    /// Configures the period days counter
    func configureCounter() {
        let days = RealmManager.sharedInstance.daysUntilNextPeriod()
        let lastPeriod = RealmManager.sharedInstance.queryLastPeriod()
        
        if let predictionDate = lastPeriod?.predictionDate, let days = days {
            
            let daysOrDays = days == 1 ? "DAY" : "DAYS"
            
            switch true {
            case today.isBefore(.Day, ofDate: predictionDate):
                delegate?.counterLabel.text = "\(daysOrDays) UNTIL \nNEXT PERIOD"
                delegate?.daysUntilNextPeriodLabel.text = "\(days)"
            case today.isAfter(.Day, ofDate: predictionDate):
                delegate?.counterLabel.text = "\(daysOrDays) \nLATE"
                delegate?.daysUntilNextPeriodLabel.text = "\(days)"
            case today.isInToday():
                delegate?.counterLabel.text = "PERIOD STARTS \nTODAY"
                delegate?.daysUntilNextPeriodLabel.text = "\(days)"
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
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        let cell = cell as! CellView
        cell.setupCellBeforeDisplay(cellState, date: date)
        if cellState.dateBelongsTo == .ThisMonth {
            cell.userInteractionEnabled = true
        } else {
            cell.userInteractionEnabled = false
        }
        
        // Circle prediction date, default 28 days
        displayPredictionDate(cell, date: date, cellState: cellState)
    }
    
    // User selects a date
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        let cell = cell as! CellView
        cell.cellSelectionChanged(cellState, date: date)
        
        RealmManager.sharedInstance.updateOrBeginNewObject(date)
        updateUIForSelection()
        
        configureCounter()
    }
    
    // User deselects a date
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        let cell = cell as! CellView
        cell.cellSelectionChanged(cellState, date: date)
        
        RealmManager.sharedInstance.updateOrDeleteObject(date)
        updateUIForDeselection()
        
        configureCounter()
        
    }
    
    // Set month name label and year label
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        delegate?.monthNameLabel.text = startDate.monthName
        delegate?.yearLabel.text = String(startDate.year)
    }
}
