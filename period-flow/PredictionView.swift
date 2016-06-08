//
//  PredictionView.swift
//  period-flow
//
//  Created by Antonija Pek on 08/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

import UIKit

class PredictionView: UIView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 2.0
        self.layer.borderColor = Color.red.CGColor
        self.layer.borderWidth = 1.0
    }
    
}
