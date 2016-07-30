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
import GoogleMobileAds

class CalendarViewController: UIViewController, CalendarViewManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var averageCycleDaysLabel: UILabel!
    @IBOutlet weak var daysUntilNextPeriodLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var counterLabel: UILabel!
    
    // MARK: - Properties
    
    var dataProvider: CalendarDataProvider?
    var viewManager: CalendarViewManager?
    var purchaseManager: PurchaseManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAdMob()
        setupDataProvider()
        setupViewManager()
        setupCalendar()
        DefaultsManager.unlockProPack()
        LocalNotificationsManager.registerNotification() // Delete that
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.scrollToDate(NSDate.today())
        viewManager?.updateUIforCycleDays()
        
        // Check if user purchased PRO Pack
//        if DefaultsManager.isProPackUnlocked() {
//            bannerView.hidden = true
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Methods
    
    func setupAdMob() {
        let request = GADRequest()
        request.testDevices = ["2c7073a24ea8e6ba2a519bd8c2b5297e", kGADSimulatorID]
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-2949684951870263/9071981034"
        bannerView.rootViewController = self
        bannerView.loadRequest(request)
    }
    
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
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.cellInset = CGPoint(x: 2, y: 2)
        calendarView.allowsMultipleSelection = true
        calendarView.firstDayOfWeek = .Sunday
        calendarView.scrollEnabled = true
        averageCycleDaysLabel.text = "\(DefaultsManager.getCycleDays())"
    }

}


