//
//  UIButton+Circle.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 26.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

extension UIButton {
    
    func asCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
    
}
