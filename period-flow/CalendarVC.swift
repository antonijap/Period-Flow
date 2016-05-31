//
//  ViewController.swift
//  period-flow
//
//  Created by Antonija Pek on 31/05/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftDate

class CalendarVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    // MARK: - Properties
    
    var dataProvider: CalendarDataProvider?

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataProvider()
        setupCalendar()
    }
    
    // MARK: - Methods
    
    func setupDataProvider() {
        dataProvider = CalendarDataProvider(calendarView: calendarView)
        calendarView.delegate = dataProvider
        calendarView.dataSource = dataProvider
    }
    
    func setupCalendar() {
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.registerCellViewXib(fileName: "CellView")
    }
}

