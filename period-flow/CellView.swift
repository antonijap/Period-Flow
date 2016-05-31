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
        configureTextColor(cellState)
        
        if date == today {
            dateLabel.textColor = Color.red
        } else {
            dateLabel.textColor = Color.grey
        }
    }
    
    func configureTextColor(cellState: CellState) {
        if cellState.dateBelongsTo == .ThisMonth {
            dateLabel.textColor = Color.grey
        } else {
            dateLabel.textColor = Color.lightGrey
        }
    }
    
    func cellSelectionChanged(cellState: CellState) {
        if cellState.isSelected == true {
            selectedDay.hidden = true
            dateLabel.textColor = Color.grey
        } else {
            selectedDay.hidden = false
            dateLabel.textColor = Color.white
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
