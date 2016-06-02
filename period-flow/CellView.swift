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
    
    // MARK: - Properties
    
    let today = NSDate.today()
    
    // MARK: - Methods
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        dateLabel.text = cellState.text

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
        } else {
            selectedDayView.hidden = true
            configureTextColor(cellState, date: date)
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
}
