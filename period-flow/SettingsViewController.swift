//
//  ViewController.swift
//  period-flow
//
//  Created by Antonija Pek on 28/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var notificationStack: UIStackView!
    @IBOutlet weak var baseAnalysisStack: UIStackView!
    @IBOutlet weak var analysisStack: UIStackView!
    @IBOutlet weak var purchaseStack: UIStackView!
    
    @IBOutlet weak var averageCycleDurationLabel: UILabel!
    @IBOutlet weak var averagePeriodDurationLabel: UILabel!
    
    @IBOutlet weak var cycleDurationButton: CustomButton!
    @IBOutlet weak var notificationButton: CustomButton!
    @IBOutlet weak var baseAnalysisButton: CustomButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Methods
    
    // MARK: Actions
    
    @IBAction func cycleDurationButtonTapped(sender: AnyObject) {
    }

    @IBAction func notificationButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func baseAnalysisButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func purchaseTapped(sender: AnyObject) {
        print("I want to purchase")
    }
    
    @IBAction func restoreButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
