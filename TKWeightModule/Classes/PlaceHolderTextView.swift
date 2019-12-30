//
//  UITextView+PlaceHolder.swift
//  Pods-TKBase-Swift_Tests
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit


/// Place holder TextView

public class PlaceHolderTextView: UITextView {


    /// placehoder text
    public var placehoder : String? {
        
        didSet {
            
            // 设置文字
            self.placehoderLabel?.text = placehoder;
            
            if placehoderLabel?.text == nil {
                
                return;
            }
            // 重新计算子控件的frame
            setNeedsLayout();
            
        }
    };

    /// place holder text Color
    public var placehoderColor : UIColor = UIColor.black {
        
        didSet {
            
            // 设置颜色
            self.placehoderLabel?.textColor = placehoderColor;
            
        }
    };

    private var placehoderLabel : UILabel?
    // 监听内部文字的改变
    override public var text: String! {
        
        didSet {
            
            
            textDidChange();
        }
    }
    
    override public var font: UIFont? {
        
        didSet {
            
            self.placehoderLabel?.font = font
            // 重新计算子控件的frame
            setNeedsLayout();
            
            
        }
    }
    
    override public var attributedText: NSAttributedString! {
        
        didSet {
            
            textDidChange();
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self);
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer);
        // 清空颜色
        backgroundColor = UIColor.clear
        // 添加一个显示提醒文字的label（显示占位文字的label）
        placehoderLabel = UILabel()
        placehoderLabel?.numberOfLines = 0
        placehoderLabel?.textColor = placehoderColor
        placehoderLabel?.backgroundColor = UIColor.clear
        addSubview(placehoderLabel!)
        
        // 设置颜色的占位文字颜色
        placehoderLabel?.textColor = UIColor.lightGray;
        // 设置默认的字体
        font = UIFont.systemFont(ofSize: 14);
        
        // 监听文字改变
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self);
        
    }
    
    
    @objc func textDidChange() -> Void {
        
        placehoderLabel?.isHidden = hasText;
        
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews();
        
        let placehoderLabelX = CGFloat(5);
        let placehoderLabelY = CGFloat(8);
        let placehoderLabelW = self.frame.size.width - 2 * placehoderLabelX;
        //        CGSize(placehoderLabelW, CGFloat(MAXFLOAT));
        let maxSize = CGSize(width: placehoderLabelW, height: CGFloat(MAXFLOAT))
        let placeAttrs = [NSAttributedStringKey : AnyObject]();
        let placehoderLabelRect = (placehoder! as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: placeAttrs as [NSAttributedStringKey : AnyObject], context: nil);
        let placehoderLabelH = placehoderLabelRect.size.height;
        //        CGRect(placehoderLabelX, placehoderLabelY, placehoderLabelW, placehoderLabelH);
        placehoderLabel?.frame = CGRect(x: placehoderLabelX, y: placehoderLabelY, width: placehoderLabelW, height: placehoderLabelH)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
