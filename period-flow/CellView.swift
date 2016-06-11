//
//  CellView.swift
//  period-flow
//
//  Created by Antonija Pek on 31/05/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import JTAppleCalendar
import SwiftDate

class CellView: JTAppleDayCellView {
    
    // MARK: - IBOutlets
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var selectedDayView: SelectionView!
    @IBOutlet weak var todayView: SelectionView!
    @IBOutlet weak var predictionDay: PredictionView!
    
    // MARK: - Properties
    
    let today = NSDate.today()
    
    // MARK: - Methods
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        dateLabel.text = cellState.text
        predictionDay.hidden = true
        configureTextColor(cellState, date: date)
        configureBackgroundColor(cellState, date: date)
        configureTodayView(date)
    }
    
    func configureTextColor(cellState: CellState, date: NSDate) {
        if cellState.dateBelongsTo == .ThisMonth {
            dateLabel.textColor = Color.grey
        } else {
            dateLabel.textColor = Color.lightGrey
        }
    }
    
    func configureBackgroundColor(cellState: CellState, date: NSDate) {
        if cellState.isSelected  {
            selectedDayView.hidden = false
            dateLabel.textColor = Color.white
        } else if cellState.isSelected == false {
            selectedDayView.hidden = true
            configureTextColor(cellState, date: date)
        } else if cellState.dateBelongsTo == .PreviousMonthWithinBoundary && cellState.isSelected {
            selectedDayView.layer.backgroundColor = Color.red.colorWithAlphaComponent(0.2).CGColor
        } else if cellState.dateBelongsTo == .FollowingMonthWithinBoundary && cellState.isSelected {
            selectedDayView.layer.backgroundColor = Color.red.colorWithAlphaComponent(0.2).CGColor
        }
    }
    
    func configureTodayView(date: NSDate) {
        if date == today {
            todayView.hidden = false
        } else {
            todayView.hidden = true
        }
    }
    
    func cellSelectionChanged(cellState: CellState, date: NSDate) {
        if cellState.isSelected  {
            selectedDayView.hidden = false
            dateLabel.textColor = Color.white
        } else {
            selectedDayView.hidden = true
            dateLabel.textColor = Color.grey
        }
    }
    
    /// Display red border on a date that predict future period
    func displayPrediction(isBleeding: Bool, cellState: CellState){
        if isBleeding && cellState.dateBelongsTo == .ThisMonth {
            predictionDay.hidden = false
        } else if isBleeding == false && cellState.dateBelongsTo == .ThisMonth {
            predictionDay.hidden = true
        } else if isBleeding && cellState.dateBelongsTo == .PreviousMonthWithinBoundary {
            predictionDay.hidden = false
            predictionDay.layer.borderColor = Color.red.colorWithAlphaComponent(0.4).CGColor
        } else if isBleeding && cellState.dateBelongsTo == .FollowingMonthWithinBoundary {
            predictionDay.hidden = false
            predictionDay.layer.borderColor = Color.red.colorWithAlphaComponent(0.4).CGColor
        }
    }
}
