//
//  FirstViewAnimation.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 26.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class FirstViewAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    
    private let duration: TimeInterval = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? FirstViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? MainViewController
        else { return }
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let screen = UIScreen.main.bounds
        
        let redAnimation = CABasicAnimation(keyPath: "position")
        redAnimation.fromValue = fromVC.redImage.center
        redAnimation.toValue = CGPoint(x: screen.size.width / 2, y: (screen.size.height / 2) - 100 )
        redAnimation.delegate = self
        redAnimation.duration = self.duration
        toVC.redButton.layer.add(redAnimation, forKey: "position")
        
        let greenAnimation = CABasicAnimation(keyPath: "position")
        greenAnimation.fromValue = fromVC.greenImage.center
        greenAnimation.toValue = CGPoint(x: 16 + 75, y: (screen.size.height / 2) + 80)
        greenAnimation.delegate = self
        greenAnimation.duration = self.duration
        toVC.greenButton.layer.add(greenAnimation, forKey: "position")
        
        let purpleAnimation = CABasicAnimation(keyPath: "position")
        purpleAnimation.fromValue = fromVC.purpleImage.center
        purpleAnimation.toValue = CGPoint(x: screen.size.width - (16 + 75), y: (screen.size.height / 2) + 80)
        purpleAnimation.delegate = self
        purpleAnimation.duration = self.duration
        toVC.purpleButton.layer.add(purpleAnimation, forKey: "position")
        
    }
    
    
}

extension FirstViewAnimation: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(true)
        self.transitionContext = nil
    }
    
}

