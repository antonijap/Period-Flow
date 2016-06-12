//
//  DefaultsManager.swift
//  period-flow
//
//  Created by Antonija Pek on 12/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation

class DefaultsManager {
    /// Set value in NSUserDefaults
    class func setCycleDays(value: Int) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: "cycleDays")
    }
    
    /// Get value from NSUserDefaults
    class func getCycleDays() -> Int {
        return NSUserDefaults.standardUserDefaults().valueForKey("cycleDays") as? Int ?? 28
    }
}