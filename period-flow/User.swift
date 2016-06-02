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
    
    static var periods: List<Period> = List<Period>()
}