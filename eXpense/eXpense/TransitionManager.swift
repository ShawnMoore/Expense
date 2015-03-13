//
//  TransitionManager.swift
//  Transition
//
//  Created by Shawn Moore on 2/20/15.
//  Copyright (c) 2015 Shawn Moore. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(container.frame.width, 0)
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            fromView.alpha = 0.0
            toView.alpha = 1.0
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
                
        })
        
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.25
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    
}
