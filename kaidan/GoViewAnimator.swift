//
//  Animator.swift
//  kaidan
//
//  Created by 溝田隆明 on 2015/03/10.
//  Copyright (c) 2015年 tebcro. All rights reserved.
//

import UIKit

class GoViewAnimator: NSObject, UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning {
   
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval
    {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let list   = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as List
        let detail = transitionContext.viewControllerForKey(UITransitionContextToViewKey) as Detail
        
        UIView.animateKeyframesWithDuration(1.0,
            delay: 0.0, options: .CalculationModeCubic,
            animations: { () -> Void in
                list.view.alpha = 0.0
        }) { (success) -> Void in
            detail.view.alpha = 1.0
            list.view.alpha = 1.0
            
            transitionContext.completeTransition(true)
        }
    }
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let list   = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as List
        let detail = transitionContext.viewControllerForKey(UITransitionContextToViewKey) as Detail
        
        list.collectionView?.startInteractiveTransitionToCollectionViewLayout(detail.collectionViewLayout, completion: { (didFinish, didComplete) -> Void in
            transitionContext.containerView().addSubview(detail.view)
            transitionContext.completeTransition(didComplete)
            
            if didComplete {
                
            } else {
                
            }
        })
    }
}
