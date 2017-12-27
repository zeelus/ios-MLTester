//
//  UIViewController+TransparentNavigationBar.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 26.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setTransparentNavigationBar() {
        let navigationController = self.navigationController
        let navigationBar = navigationController?.navigationBar
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationBar?.backgroundColor = UIColor.clear
    }
    
}
