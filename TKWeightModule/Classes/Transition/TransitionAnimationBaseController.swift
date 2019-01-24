//
//  TransitionAnimationBaseController.swift
//  TKWeightModule
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit

class TransitionAnimationBaseController: UIViewController {
    fileprivate let transition = PresentTransitionAnimation()
    fileprivate let dismissTransiton = DismissTransitionAnimation()
    var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
}


extension TransitionAnimationBaseController : UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransiton
    }
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

