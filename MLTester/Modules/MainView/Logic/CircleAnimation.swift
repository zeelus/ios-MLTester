//
//  CircleAnimation.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 28.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class CircleAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 2.0
    private weak var lastPressedButton: UIButton!
    
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
            
            circle.transform = CGAffineTransform(scaleX: 100.0, y: 100.0)
            
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
