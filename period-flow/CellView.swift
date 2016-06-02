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
    @IBOutlet weak var selectedDay: SelectionView!
    
    // MARK: - Properties
    
    let today = NSDate.today()
    
    // MARK: - Methods
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        dateLabel.text =  cellState.text
        configureTextColor(cellState, date: date)
    }
    
    func configureTextColor(cellState: CellState, date: NSDate) {
        if date == today {
            dateLabel.textColor = Color.red
        } else if cellState.dateBelongsTo == .ThisMonth {
            dateLabel.textColor = Color.grey
        } else {
            dateLabel.textColor = Color.lightGrey
        }
    }
    
    func cellSelectionChanged(cellState: CellState, date: NSDate) {
        // If date is selected then background should be red with white 
        // font color. When deselected revert to no background with
        // grey font color AND if that day was today, font color should be red!
        if cellState.isSelected  {
            selectedDay.hidden = false
            dateLabel.textColor = Color.white
        } else {
            selectedDay.hidden = true
            if date == today {
                dateLabel.textColor = Color.red
            } else {
                dateLabel.textColor = Color.grey
            }
        }
        
        if cellState.isSelected {
            if selectedDay.hidden {
                selectedDay.hidden = false
                dateLabel.textColor = Color.white
            }
        } else {
            selectedDay.hidden = true
            dateLabel.textColor = Color.grey
        }
    }
}
