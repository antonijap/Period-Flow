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

class CalendarViewController: UIViewController, CalendarViewManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthNameLabel: UILabel!
    
    // MARK: - Properties
    
    var dataProvider: CalendarDataProvider?
    var viewManager: CalendarViewManager?
    let today = NSDate.today()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataProvider()
        setupViewManager()
        setupCalendar()
        displayAllDates() // This will be for selecting days in Calendar, first I need to get all days for selection
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.scrollToDate(today)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Methods
    
    func setupDataProvider() {
        dataProvider = CalendarDataProvider(calendarView: calendarView)
        calendarView.dataSource = dataProvider
    }
    
    func setupViewManager() {
        viewManager = CalendarViewManager(calendarView: calendarView)
        calendarView.delegate = viewManager
        viewManager?.delegate = self
    }
    
    func setupCalendar() {
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.cellInset = CGPoint(x: 2, y: 2)
        calendarView.allowsMultipleSelection = true
        calendarView.firstDayOfWeek = .Sunday
        calendarView.scrollEnabled = true
    }
    
    // Get all dates from period and display them
    func displayAllDates() {
        let periods = RealmManager.sharedInstance.queryAllPeriods()!
        print(periods)
        
        for period in periods {
            calendarView.selectDates(period.assumedDates, triggerSelectionDelegate: false)
            print(period.assumedDates)
        }
    }
}


