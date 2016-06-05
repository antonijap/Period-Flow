//
//  Period.swift
//  period-flow
//
//  Created by Steven on 6/2/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation
import RealmSwift

class Period: Object {
    
    // MARK: - Properties
    
    dynamic var startDate: NSDate?
    dynamic var endDate: NSDate?
    var assumedDates: [NSDate]?
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
}
