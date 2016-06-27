//
//  SettingsViewController.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var dataProvider: SettingsDataProvider?
    var viewManager: SettingsViewManager?

    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataProvider()
        setupViewManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    

    func setupDataProvider() {
        dataProvider = SettingsDataProvider(tableView: tableView)
        tableView.dataSource = dataProvider
    }
    
    func setupViewManager() {
        viewManager = SettingsViewManager(tableView: tableView)
        tableView.delegate = viewManager
        viewManager?.delegate = self
    }

    // MARK: - IBActions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

    // MARK: - Extension: SettingsViewManagerDelegate

extension SettingsViewController: SettingsViewManagerDelegate {
    
    // MARK: - Navigation
    
    func showPurchaseController() {
        performSegueWithIdentifier("ShowPurchase", sender: self)
    }
}
