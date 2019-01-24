//
//  PresentTransitionAnimation.swift
//  TKWeightModule
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit

class PresentTransitionAnimation: NSObject, CAAnimationDelegate, UIViewControllerAnimatedTransitioning {
    public var duration = 0.3
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? TransitionAnimationBaseController else {return}
    
        containerView.addSubview(toView.view)

        // 为目标视图的展现添加动画
        toView.view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.0)
        toView.contentView.transform = CGAffineTransform(translationX: 0, y: 352)
        
        UIView.animate(withDuration: duration,
                       animations: {
                        toView.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
                        toView.view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.2)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })

    
    
    
    }
    

}
