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
import ActionSheetPicker_3_0

class CalendarViewController: UIViewController, CalendarViewManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var averageCycleDaysLabel: UILabel!
    @IBOutlet weak var daysUntilNextPeriodLabel: UILabel!

    
    // MARK: - Properties
    
    var dataProvider: CalendarDataProvider?
    var viewManager: CalendarViewManager?
    let today = NSDate.today()
    var selectedDates = [NSDate]()
    var period = Period()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataProvider()
        setupViewManager()
        setupCalendar()
        viewManager?.displayAllDates()
        print("Days until next period: \(RealmManager.sharedInstance.daysUntilNextPeriod())")
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
        viewManager = CalendarViewManager(calendarView: calendarView, controller: self)
        calendarView.delegate = viewManager
        viewManager?.delegate = self
    }
    
    func setupCalendar() {
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.cellInset = CGPoint(x: 2, y: 2)
        calendarView.allowsMultipleSelection = true
        calendarView.firstDayOfWeek = .Sunday
        calendarView.scrollEnabled = true
        averageCycleDaysLabel.text = "\(period.cycleDays)"
        daysUntilNextPeriodLabel.text = "\(RealmManager.sharedInstance.daysUntilNextPeriod())"
    }

    // MARK: - IBActions
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        var days = [Int]()
        days += 1...100
        
        let picker = ActionSheetStringPicker(title: "Cycle duration", rows: days, initialSelection: period.cycleDays - 1, doneBlock: { picker, int, object in
                print("Picker \(picker), int: \(int), object: \(object)")
            }, cancelBlock: nil, origin: sender)
        picker.showActionSheetPicker()
    }
}


