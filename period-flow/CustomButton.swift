//
//  CustomButton.swift
//  period-flow
//
//  Created by Antonija Pek on 28/06/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = Color.borderColor.CGColor
        self.layer.borderWidth = 1.0
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
    }

}
