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
    func toPlaces(number: Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = number
        return formatter.stringFromNumber(self) ?? "\(self)"
    }
}

// Extension: Array

extension Array where Element: IntegerType {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, combine: +)
    }
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(total.hashValue) / Double(count)
    }
}