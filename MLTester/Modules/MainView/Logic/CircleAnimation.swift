//
//  CircleAnimation.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 28.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class CircleAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate let duration: TimeInterval = 1.0
    fileprivate weak var lastPressedButton: UIButton!
    
    init(lastPressedButton: UIButton) {
        self.lastPressedButton = lastPressedButton
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromSnap = fromVC.view.snapshotView(afterScreenUpdates: false)
        else { return }
        
        transitionContext.containerView.addSubview(toVC.view)
        transitionContext.containerView.addSubview(fromSnap)
        
        let circle = UIView()
        circle.frame = self.lastPressedButton.frame
        circle.layer.cornerRadius = circle.frame.width / 2
        circle.backgroundColor = self.lastPressedButton.backgroundColor
        
        transitionContext.containerView.addSubview(circle)
        
        UIView.animate(withDuration: self.duration / 2, animations: {
            
            circle.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
            
        }) { (finished) in
            guard finished else { return }
            UIView.animate(withDuration: (self.duration / 2), animations: {
                fromSnap.alpha = 0.0
            }, completion: { (finished) in
                guard finished else { return }
                circle.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
        
    }
    
}

class CircleAnimationBack: CircleAnimation {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        
        transitionContext.containerView.addSubview(fromVC.view)
        
        let circle = UIView()
        circle.frame = self.lastPressedButton.frame
        circle.layer.cornerRadius = circle.frame.width / 2
        circle.backgroundColor = self.lastPressedButton.backgroundColor
        circle.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
        circle.alpha = 0.0
        
        transitionContext.containerView.addSubview(circle)
        
        UIView.animate(withDuration: self.duration / 2, animations: {
            
            circle.alpha = 1.0
            
        }) { (finished) in
            guard finished else { return }
            fromVC.view.removeFromSuperview()
            transitionContext.containerView.insertSubview(toVC.view, at: 1)
            
            UIView.animate(withDuration: self.duration / 2, animations: {
                
                circle.transform = .identity
                
            }, completion: { (finished) in
                guard finished else { return }
                circle.removeFromSuperview()
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
            
        }
        
        
        
    }
}
