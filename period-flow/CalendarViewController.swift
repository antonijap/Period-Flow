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

@available(iOS 10.0, *)
class CalendarViewController: UIViewController, CalendarViewManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var daysUntilNextPeriodLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    // MARK: - Properties
    
    var dataProvider: CalendarDataProvider?
    var viewManager: CalendarViewManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataProvider()
        setupCalendar()
        setupViewManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAnalytics() // TODO: - Uncomment this before release
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        calendarView.scrollToDate(Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        viewManager?.displayAllDates()
        viewManager?.configureCounter()
    }
    
    func setupCalendar() {
        calendarView.registerCellViewXib(file: "CellView")
        calendarView.cellInset = CGPoint(x: 2, y: 2)
        calendarView.allowsMultipleSelection = true
        calendarView.scrollEnabled = true
        
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.month,.day,.year], from: Date())
        
        let monthName = calendar.monthSymbols[components.month! - 1]
        let year = components.year!

        monthNameLabel.text = String(monthName)
        yearLabel.text = String(year)
    }
    
    func setUpAnalytics() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Calendar Screen")
        let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
        tracker?.send(build)
    }

}


