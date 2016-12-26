//
//  FullButton.swift
//  period-flow
//
//  Created by Antonija on 26/12/2016.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class FullButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4.0
    }
}
