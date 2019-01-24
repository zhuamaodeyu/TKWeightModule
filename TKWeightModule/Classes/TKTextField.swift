//
//  TKTextField.swift
//  Pods-TKBase-Swift_Tests
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit


extension UITextField {
    func tk_SetClearButton(image: String) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: image), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    @objc func clear(sender : AnyObject) {
        self.text = ""
    }
    
    func setLeftView(leftView: UIView) {
        let v = UIView()
        v.addSubview(leftView)
        v.frame = leftView.bounds
        self.rightView = v
        self.rightViewMode = .always
    }
}

class TKTextField: UITextField {

    var lineColor: UIColor?
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var  rect = super.editingRect(forBounds: bounds)
        rect.origin.x += 10
        return rect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var  rect = super.placeholderRect(forBounds: bounds)
        rect.origin.x += 20
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += 10
        return rect
    }
    
    // 下划线  
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.lineColor != nil {
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(lineColor!.cgColor)
            context?.fill(CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5))
        }
    }
}


