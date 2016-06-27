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
    
    /// This is called whenever cell is render to the screen
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        dateLabel.text = cellState.text
        predictionDay.hidden = true
        configureTextColor(cellState)
        configureBackgroundColor(cellState, date: date)
        configureTodayView(date)
    }
    
    /// .ThisMonth is grey, otherwise it's light grey
    func configureTextColor(cellState: CellState) {
        if cellState.dateBelongsTo == .ThisMonth {
            dateLabel.textColor = Color.grey
        } else {
            dateLabel.textColor = Color.lightGrey
        }
    }
    
    /// Configures background color based of enum cellState.dateBelongsTo
    func configureBackgroundColor(cellState: CellState, date: NSDate) {
        if cellState.isSelected {
            selectedDayView.hidden = false
            dateLabel.textColor = Color.white
            if cellState.dateBelongsTo == .PreviousMonthWithinBoundary {
                selectedDayView.layer.backgroundColor = Color.lightMint.CGColor
            } else if cellState.dateBelongsTo == .FollowingMonthWithinBoundary {
                selectedDayView.layer.backgroundColor = Color.lightMint.CGColor
            } else {
                selectedDayView.layer.backgroundColor = Color.mint.CGColor
            }
        } else {
            selectedDayView.hidden = true
            configureTextColor(cellState)
        }
    }
    
    /// Configures the view for the current date
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
            predictionDay.layer.borderColor = Color.lightMint.CGColor
        } else if isBleeding && cellState.dateBelongsTo == .FollowingMonthWithinBoundary {
            predictionDay.hidden = false
            predictionDay.layer.borderColor = Color.lightMint.CGColor
        }
    }
}
