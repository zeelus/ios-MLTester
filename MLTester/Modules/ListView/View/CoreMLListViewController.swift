//
//  CoreMLListViewController.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 09.01.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class CoreMLListViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func setCornerRadius() {
        self.mainView.layer.cornerRadius = 20.0
        self.mainView.layer.masksToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        setCornerRadius()
    }

    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
