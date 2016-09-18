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
    
    let today = Date.today()
    
    // MARK: - Methods
    
    /// This is called whenever cell is render to the screen
    func setupCellBeforeDisplay(_ cellState: CellState, date: Date) {
        dateLabel.text = cellState.text
        predictionDay.isHidden = true
        configureTextColor(cellState: cellState)
        configureBackgroundColor(cellState, date: date)
        configureTodayView(date: date as Date)
    }
    
    /// .ThisMonth is grey, otherwise it's light grey
    func configureTextColor(cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dateLabel.textColor = Color.grey
        } else {
            dateLabel.textColor = Color.lightGrey
        }
    }
    
    /// Configures background color based of enum cellState.dateBelongsTo
    func configureBackgroundColor(_ cellState: CellState, date: Date) {
        if cellState.isSelected {
            selectedDayView.isHidden = false
            dateLabel.textColor = Color.white
            if cellState.dateBelongsTo == .previousMonthWithinBoundary {
                selectedDayView.layer.backgroundColor = Color.lightMint.cgColor
            } else if cellState.dateBelongsTo == .followingMonthWithinBoundary {
                selectedDayView.layer.backgroundColor = Color.lightMint.cgColor
            } else {
                selectedDayView.layer.backgroundColor = Color.mint.cgColor
            }
        } else {
            selectedDayView.isHidden = true
            configureTextColor(cellState: cellState)
        }
    }
    
    /// Configures the view for the current date
    func configureTodayView(date: Date) {
        if date == today {
            todayView.isHidden = false
        } else {
            todayView.isHidden = true
        }
    }
    
    func cellSelectionChanged(_ cellState: CellState, date: NSDate) {
        if cellState.isSelected  {
            selectedDayView.isHidden = false
            dateLabel.textColor = Color.white
        } else {
            selectedDayView.isHidden = true
            dateLabel.textColor = Color.grey
        }
    }
    
    /// Display red border on a date that predict future period
    func displayPrediction(_ isBleeding: Bool, cellState: CellState){
        if isBleeding && cellState.dateBelongsTo == .thisMonth {
            predictionDay.isHidden = false
        } else if isBleeding == false && cellState.dateBelongsTo == .thisMonth {
            predictionDay.isHidden = true
        } else if isBleeding && cellState.dateBelongsTo == .previousMonthWithinBoundary {
            predictionDay.isHidden = false
            predictionDay.layer.borderColor = Color.lightMint.cgColor
        } else if isBleeding && cellState.dateBelongsTo == .followingMonthWithinBoundary {
            predictionDay.isHidden = false
            predictionDay.layer.borderColor = Color.lightMint.cgColor
        }
    }
}
