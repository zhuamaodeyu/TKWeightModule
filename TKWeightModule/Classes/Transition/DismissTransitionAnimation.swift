//
//  DismissTransitionAnimation.swift
//  TKWeightModule
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit

class DismissTransitionAnimation: NSObject,CAAnimationDelegate, UIViewControllerAnimatedTransitioning  {

    public var duration = 0.3
    
    // 指定转场动画持续的时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 实现转场动画的具体内容
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? TransitionAnimationBaseController else {return}
        
        
        toView.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
        toView.view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.2)
        UIView.animate(withDuration: duration,
                       animations: {
                        toView.contentView.transform = CGAffineTransform(translationX: 0, y: 352)
                        toView.view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.0)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })

    }
}
