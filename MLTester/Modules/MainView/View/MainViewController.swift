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
    @IBOutlet weak var listButtonView: UIView!
    @IBOutlet weak var listButton: UIButton!
    
    private weak var lastPressedButton: UIButton?
    
    private var isLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTransparentNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.delegate = self
        
        if !self.isLoad {
            self.addInAnimationToListButtonView()
            self.isLoad = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let modelName = CoreMLProvider.instance.getSelectedModel()?.name
        self.listButton.setTitle(modelName, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.redButton.asCircle()
        self.greenButton.asCircle()
        self.purpleButton.asCircle()
        self.setCornerToListButtonView()
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
    
    @IBAction func listButtonPressed(_ sender: Any) {
        let vc = StoryboardManager.getCoreMLList()
        vc.modalPresentationStyle = .overCurrentContext
        vc.dismissBlock = { [weak self] in
            let modelName = CoreMLProvider.instance.getSelectedModel()?.name
            self?.listButton.setTitle(modelName, for: .normal)
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    private func setCornerToListButtonView() {
        self.listButtonView.layer.cornerRadius = self.listButtonView.layer.bounds.height / 3
        self.listButtonView.layer.masksToBounds = true
    }
    
    private func addInAnimationToListButtonView() {
        //self.listButtonView.alpha = 0.0
        let position = self.listButtonView.center
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: position.x, y: position.y + 250 )
        animation.toValue = position
        animation.duration = 1.0
        animation.repeatCount = 1
        self.listButtonView.layer.add(animation, forKey: "position")
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
