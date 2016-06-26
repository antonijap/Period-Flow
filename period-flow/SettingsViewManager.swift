//
//  SettingsViewManager.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol SettingsViewManagerDelegate {
    func showPurchaseController() -> Void
}

class SettingsViewManager: NSObject {
    
    // MARK: - Properties
    
    var tableView: UITableView
    var delegate: SettingsViewManagerDelegate?
    
    // MARK: - Initializers
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - Methods
    
    func displayActionSheet(sender: AnyObject) {
        
        var days = [Int]()
        days += 1...100
        
        let doneBlock = { (picker: ActionSheetStringPicker!, int: Int, object: AnyObject!) in
            if let object = object as? Int {
                DefaultsManager.setCycleDays(object)
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Cycle duration", rows: days, initialSelection: DefaultsManager.getCycleDays() - 1,
                                             doneBlock: doneBlock, cancelBlock: nil, origin: sender)
        
        picker.showActionSheetPicker()
        
    }

}

extension SettingsViewManager: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0: displayActionSheet(tableView)
        case 1: delegate?.showPurchaseController()
        default: break
        }
    }
}
