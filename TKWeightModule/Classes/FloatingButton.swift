//
//  FloatingButton.swift
//  U17
//
//  Created by akulaku on 2019/3/21.
//  Copyright © 2019年 None. All rights reserved.
//

import UIKit

public enum EdgePolicyType {
    case all            // 所有
    case leftRight      // 左右
    case upDown         // 上下
}

fileprivate enum PositionType {
    case top
    case down
    case left
    case right
}

public protocol FloatingButtonDelegate:class {
    func floatintButtonClick(floatingButton: FloatingButton)
}

public class FloatingButton: UIButton {
    private var moving: Bool = false
    private var sleeping: Bool = false
    
    private var beginPoint: CGPoint = CGPoint.zero
    private var beginOrigin: CGPoint =  CGPoint.zero


    public  var sleepOffset: Float = 0
    public  var sleepAlpha: Float = 0.5
    public  var openSleep: Bool = false
    

    /// 靠边策略
    public var edgePolicy : EdgePolicyType = .all
    
    /// 是否自动吸附边界
    public var autoAdsorptionSide: Bool = false
    
    
    public weak var delegate: FloatingButtonDelegate?
    
    
    
    public init(normalImage:UIImage,highlightedImage:UIImage? = nil, edgePolicy: EdgePolicyType = .leftRight , openSleep: Bool = false ,autoAdsorptionSide: Bool = false, sleepAlpha: Float = 0.5, sleepOffset: Float = 0) {
        self.edgePolicy = edgePolicy
        self.openSleep = openSleep
        self.autoAdsorptionSide = autoAdsorptionSide
        self.sleepAlpha = sleepAlpha
        self.sleepOffset = sleepOffset
        
        super.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 200), size: normalImage.size))
        
        self.setBackgroundImage(normalImage, for: .normal)
        self.setBackgroundImage(highlightedImage, for: .highlighted)
        self.adjustsImageWhenHighlighted = true
        self.sizeToFit()
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        if openSleep {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.autoBeginSleep()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FloatingButton {
    /// 显示全部
    @objc private func autoBeginSleep() {
        UIView.animate(withDuration: 0.5, animations: {
            if self.frame.minY == 0 {
                self.frame = CGRect.init(origin: CGPoint.init(x:self.frame.minX, y: -self.frame.height / 2), size: self.frame.size)
            }
            if self.frame.minX == 0 {
                self.frame = CGRect.init(origin: CGPoint.init(x: -self.frame.width / 2, y: self.frame.minY), size: self.frame.size)
            }
            
            guard let superview = self.superview else {
                return
            }
            
            if self.frame.maxY == superview.frame.height {
                self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.minX, y: self.frame.minY + self.frame.height / 2), size: self.frame.size)
            }
            if self.frame.maxX == superview.frame.width {
                self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.minX + self.frame.width / 2, y: self.frame.minY), size: self.frame.size)
            }
            self.alpha = CGFloat(self.sleepAlpha)
        }) { (result) in
            self.sleeping = true
        }
    }
    
    /// 显示部分
    private func autoEndSleep() {
        UIView.animate(withDuration: 0.5, animations: {
            if self.frame.minX < 0 {
                 self.frame = CGRect.init(origin: CGPoint.init(x:0, y: self.frame.minY), size: self.frame.size)
            }
            if self.frame.minY < 0 {
                self.frame = CGRect.init(origin: CGPoint.init(x:self.frame.minX, y: 0), size: self.frame.size)
            }
            guard let superview = self.superview else {
                return
            }
            
            if self.frame.maxX > superview.frame.width {
                self.frame = CGRect.init(origin: CGPoint.init(x:superview.frame.width - self.frame.width, y: self.frame.minY), size: self.frame.size)
            }
            
            if self.frame.maxY > superview.frame.height {
                self.frame = CGRect.init(origin: CGPoint.init(x:self.frame.minX, y: superview.frame.height - self.frame.height), size: self.frame.size)
            }
            
            self.alpha = 1.0
        }) { (result) in
            self.sleeping = false
        }
    }
    
}
extension FloatingButton {
    
    /// Action
    @objc private func buttonAction() {
        if moving {
            return
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.delegate?.floatintButtonClick(floatingButton: self)
        self.perform(#selector(autoBeginSleep), with: "\(self)", afterDelay: 3)
    }
}

// MARK: - Action
extension FloatingButton {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sleeping {
            autoEndSleep()
            self.perform(#selector(autoBeginSleep), with: "\(self)", afterDelay: 3)
            return
        }
        super.touchesBegan(touches, with: event)
        guard let touch  = touches.first else {
            return
        }
        self.beginPoint = touch.location(in: self)
        self.beginOrigin = self.frame.origin
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moving = true
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        guard let touch = touches.first else {
            return
        }
        
        let position = touch.location(in: self)
        let offsetX = position.x - self.beginPoint.x
        let offsetY = position.y - self.beginPoint.y
        
        /// 绝对值
        self.center = CGPoint(x: self.center.x + offsetX, y: self.center.y + offsetY)
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sleeping {
            return
        }
        
        guard let superview = self.superview else {
            return
        }
        
        switch self.edgePolicy {
        case .upDown:
            var  x = self.frame.minX > 0 ? self.frame.minX : 0
            x = self.frame.maxX > superview.frame.width ? superview.frame.width - self.frame.width : x
            UIView.animate(withDuration: 0.2) {
                if self.center.y >= superview.frame.height / 2 {
                    self.frame = CGRect.init(x: x, y: superview.frame.height - self.frame.height, width: self.frame.width, height: self.frame.height)
                }else {
                    self.frame = CGRect.init(x: x, y: 0, width: self.frame.width, height: self.frame.height)
                }
            }
            break
        case .leftRight:
            var y = self.frame.minY > 0 ? self.frame.minY : 0
            y = self.frame.maxY > superview.frame.height ? superview.frame.height - self.frame.height : y
            UIView.animate(withDuration: 0.2) {
                if self.center.x >= superview.frame.width / 2 {
                    self.frame = CGRect(x: superview.frame.width - self.frame.width, y: y, width: self.frame.width, height: self.frame.height)
                }else {
                    self.frame = CGRect(x: 0, y: y, width: self.frame.width, height: self.frame.height)
                }
            }
            break
        case .all:
            fallthrough
        default:
            switch self.position(superView: superview, with: self.center) {
            case .top:
                break
            case .down:
                break
            case .left:
                break
            case .right:
                break
            }
        }
        
        super.touchesEnded(touches, with: event)
        moving = false
        
        if openSleep {
            self.perform(#selector(autoBeginSleep), with: "\(self)", afterDelay: 3)
        }
    }
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        moving = false
        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect.init(origin: self.beginOrigin, size: self.frame.size)
        }
        if openSleep {
            self.perform(#selector(autoBeginSleep), with: "\(self)", afterDelay: 3)
        }
    }
}

extension FloatingButton {
        /// point self center
    private func position(superView: UIView ,with point: CGPoint) -> PositionType {
        let superViewCenter = superView.center
        
        let xOffset = superViewCenter.x - point.x
        let yOffset = superViewCenter.y - point.y
        
        if xOffset > 0 {
            //偏 左
            
            
            
        }else {
            // 偏右
            
            
        }
        
        return .left
    }
}
