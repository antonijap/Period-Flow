//
//  Constants.swift
//  period-flow
//
//  Created by Steven on 6/26/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation

// MARK: - Product Identifiers

let PURCHASE_PROPACK = "com.antonijapek.periodflow.propack"

// MARK: - NSUserDefaults Keys

let KEY_CYCLE_DAYS = "CycleDays"
let KEY_NOTIF_DAYS = "NotificationDays"
let KEY_ANALYSIS = "AnalysisNumber"
let KEY_PRO_PACK = "ProPack"


// Extension: Double

extension Double {
    /// Formats a Double to specified number of digits
    func toPlaces(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = number
        return formatter.string(from: NSNumber(self)) ?? "\(self)"
    }
}

// Extension: Array

extension Array where Element: Integer {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(total.hashValue) / Double(count)
    }
}
