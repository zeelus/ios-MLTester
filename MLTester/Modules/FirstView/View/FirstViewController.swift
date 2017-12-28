//
//  FirstViewController.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 26.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var redImage: UIImageView!
    @IBOutlet weak var greenImage: UIImageView!
    @IBOutlet weak var purpleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.goToMainView()
    }
    
    func goToMainView() {
        guard let vc = UIStoryboard(name: "MainView", bundle: nil).instantiateInitialViewController() else { return }
        vc.transitioningDelegate = self
        vc.setTransparentNavigationBar()
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension FirstViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FirstViewAnimation()
    }
}

