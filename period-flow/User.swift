//
//  User.swift
//  period-flow
//
//  Created by Steven on 5/31/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Properties
    var periods: [Period]
    
    // MARK: - Initializers
    init() {
        self.periods = [Period]()
    }
}