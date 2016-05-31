//
//  User.swift
//  period-flow
//
//  Created by Steven on 5/31/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object {
    
    // MARK: - Properties
    
    dynamic var periods: List<Period>
    
    // MARK: - Initializers
    
//    init() {
//        self.periods = [Period]()
//    }
}