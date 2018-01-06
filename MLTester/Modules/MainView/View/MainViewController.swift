//
//  MainViewController.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 26.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    private weak var lastPressedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTransparentNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.redButton.asCircle()
        self.greenButton.asCircle()
        self.purpleButton.asCircle()
    }
    
    @IBAction func realTimeButtonPressed(_ sender: UIButton) {
        self.lastPressedButton = sender
        let vc = StoryboardManager.getRealTime()
        vc.view.backgroundColor = sender.backgroundColor
        self.show(vc, sender: self)
    }
    
    @IBAction func makePhotoButtonPressed(_ sender: UIButton) {
        self.lastPressedButton = sender
        let vc = StoryboardManager.getImageCamera()
        vc.view.backgroundColor = sender.backgroundColor
        self.show(vc, sender: self)
    }
    
    @IBAction func galleryButtonPressed(_ sender: UIButton) {
        self.lastPressedButton = sender
        let vc = StoryboardManager.getImageGallery()
        vc.view.backgroundColor = sender.backgroundColor
        self.show(vc, sender: self)
    }

}

extension MainViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let button = self.lastPressedButton else { return nil }

        if fromVC  is MainViewController {
            return CircleAnimation(lastPressedButton: button)
        }
        
        if toVC is MainViewController {
            return CircleAnimationBack(lastPressedButton: button)
        }
        
        return nil
    }
}
