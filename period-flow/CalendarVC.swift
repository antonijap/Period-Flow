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
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthNameLabel: UILabel!
    
    // MARK: - Properties
    
    var dataProvider: CalendarDataProvider?
    let today = NSDate.today()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setupDataProvider()
        setupLabels()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Methods
    
    func setupDataProvider() {
        dataProvider = CalendarDataProvider(calendarView: calendarView)
        calendarView.delegate = dataProvider
        calendarView.dataSource = dataProvider
    }
    
    func setupCalendar() {
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.cellInset = CGPoint(x: 2, y: 2)
        calendarView.allowsMultipleSelection = true
        calendarView.firstDayOfWeek = .Sunday
        calendarView.scrollEnabled = true
    }
    
    func setupLabels() {
        calendarView.scrollToDate(today)
        if let dataProvider = dataProvider {
            print("I'm in CalendarVC. Month label is \(dataProvider.monthName)")
            yearLabel.text = dataProvider.year
            monthNameLabel.text = dataProvider.monthName
        }
    }
}

