//
//  TKErrorTextField.swift
//  TKWeightModule
//
//  Created by 聂子 on 2019/1/25.
//

import Foundation
import SnapKit


enum AnimationType {
    case begin
    case reduction
}

protocol InputTextViewDelegate: class  {
    func textInputDidBeginEditing(textInput: UITextField)
    func textInputDidEndEditing(textInput: UITextField)
    func textInputDidChange(textInput: UITextField)
    func textInput(textInput: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    func textInputShouldBeginEditing(textInput: UITextField) -> Bool
    func textInputShouldEndEditing(textInput: UITextField) -> Bool
    func textInputShouldReturn(textInput: UITextField) -> Bool
    func textInputValueChange(textInput: UITextField)
    func textInputShouldClear(textInput: UITextField) -> Bool
    @available(iOS 10.0, *)
    func textInputDidEndEditing(_ textInput: UITextField, reason: UITextFieldDidEndEditingReason)
    
}
extension InputTextViewDelegate {
    func textInputDidBeginEditing(textInput: UITextField) {
        
    }
    func textInputDidEndEditing(textInput: UITextField){
        
    }
    func textInputDidChange(textInput: UITextField){
        
    }
    
    func textInput(textInput: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        return true
    }
    func textInputShouldBeginEditing(textInput: UITextField) -> Bool{
        return true
    }
    func textInputShouldEndEditing(textInput: UITextField) -> Bool {
        return true
    }
    func textInputShouldReturn(textInput: UITextField) -> Bool {
        return true
    }
    func textInputValueChange(textInput: UITextField){
        
    }
    func textInputShouldClear(textInput: UITextField) -> Bool {
        return true
    }
    @available(iOS 10.0, *)
    func textInputDidEndEditing(_ textInput: UITextField, reason: UITextFieldDidEndEditingReason){
        
    }
}

class InputTextField: UIControl {
    // MARK : UI
    private(set) var textField: UITextField!
    fileprivate var rightView: UIButton!
    fileprivate var buttomLine: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var errorMessageLabel: UILabel!
    fileprivate var contentLabel: UILabel!
    
    lazy var customAccessoryView : UIToolbar = {
        [unowned self] in
        let v = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        v.backgroundColor = UIColor.white
        let button = UIButton(type: .custom)
        button.setTitle("done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        let item = UIBarButtonItem(customView: button)
        let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self , action: nil)
        item1.width = v.frame.width - button.frame.width - 40
        v.setItems([item1,item], animated: true)
        return v
        }()
    
    // MARK: property
    weak var delegate: InputTextViewDelegate?
    
    
    var rightButtonBlock:(()-> Void)?
    var rightUserInteractionEnabled:Bool = false {
        didSet {
            self.rightView.isUserInteractionEnabled = rightUserInteractionEnabled
        }
    }
    var canEdit: Bool = true {
        didSet {
            if canEdit {
                contentLabel.isHidden = true
                textField.isHidden = false
                self.bringSubview(toFront: textField)
            }else {
                contentLabel.isHidden = false
                textField.isHidden = true
                self.bringSubview(toFront: contentLabel)
            }
        }
    }
    var keyboardType: UIKeyboardType? = .default {
        didSet {
            textField.keyboardType = keyboardType ?? .default
        }
    }
    var isHasToolBar : Bool? = false {
        didSet {
            if isHasToolBar == true
            {
                self.textField.inputAccessoryView = customAccessoryView
            }else {
                self.textField.inputAccessoryView = nil
            }
        }
    }
    
    // TextField property
    var placeholder: String? = "" {
        didSet {
            titleLabel.text = placeholder
        }
    }
    var font: UIFont? = UIFont.systemFont(ofSize: 14) {
        didSet {
            textField.font = font
            contentLabel.font = font
        }
    }
    var text: String? {
        didSet {
            if canEdit {
                textField.text = text
            }else {
                contentLabel.text = text
            }
            self.animationUpdate()
        }
    }
    
    // title Label property
    var title: String? = "" {
        didSet {
            titleLabel.text = title
        }
    }
    var titleFont: UIFont? = UIFont.systemFont(ofSize: 14){
        didSet {
            titleLabel.font = titleFont
        }
    }
    var titleTextColor: UIColor? = UIColor.gray {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    
    // error Message property
    var errorMessage: String? = "" {
        didSet {
            errorMessageLabel.text = errorMessage
            animationUpdate()
        }
    }
    var errorMessageTextColor: UIColor? = UIColor.red {
        didSet {
            errorMessageLabel.textColor = errorMessageTextColor
        }
    }
    var errorMessageFont: UIFont? = UIFont.systemFont(ofSize: 8) {
        didSet {
            errorMessageLabel.font = errorMessageFont
        }
    }
    // line property
    var buttomLineColor: UIColor? = UIColor.gray {
        didSet {
            buttomLine.backgroundColor = buttomLineColor
        }
    }
    var editColor: UIColor? = UIColor.red
    
    // right view property
    var rightImage: UIImage? {
        didSet {
            rightView.setImage(rightImage, for: .normal)
        }
    }
    
    fileprivate var type: AnimationType?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        addConstraints()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var result = true
        if canEdit {
            //          result = self.textField.text?.isEmpty ?? true
            result = self.textField.text == nil || self.textField.text == "" ? true : false
        }else {
            //          result = self.contentLabel.text?.isEmpty ?? true
            result =  self.contentLabel.text == nil || self.contentLabel.text == "" ? true : false
        }
        
        // 说明无值
        if result {
            let size = titleSize()
            
            var frame = CGRect.zero
            
            if canEdit {
                frame.origin.y = textField.frame.maxY - size.height - 5
                frame.origin.x = textField.frame.minX
            }else {
                frame.origin.y = contentLabel.frame.maxY - size.height - 5
                frame.origin.x = contentLabel.frame.minX
            }
            frame.size.width = size.width
            frame.size.height = size.height
            
            self.titleLabel.frame = frame
            
        }else {
            if self.type == .begin {
                return
            }
            var frame = CGRect.zero
            
            let size = titleSize()
            if canEdit {
                frame.origin.y = textField.frame.maxY - size.height - 5
                frame.origin.x = textField.frame.minX
            }else {
                frame.origin.y = contentLabel.frame.maxY - size.height - 5
                frame.origin.x = contentLabel.frame.minX
            }
            
            frame.size.width = size.width
            frame.size.height = size.height
            
            self.titleLabel.frame = frame
            
            animationUpdateTitleFrame(type: .begin)
        }
    }
}

extension InputTextField {
    fileprivate func installSubviews() {
        titleLabel = UILabel()
        titleLabel.font = titleFont
        titleLabel.textColor = titleTextColor
        titleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(titleLabel)
        
        contentLabel = UILabel()
        contentLabel.font = font
        contentLabel.numberOfLines = 0
        contentLabel.isHidden = true
        self.addSubview(contentLabel)
        
        textField = UITextField()
        textField.font = font
        textField.delegate = self
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType ?? .default
        textField.clearButtonMode = .whileEditing
        textField.rightViewMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldViewChange(textField:)), for: .editingChanged)
        self.insertSubview(textField, belowSubview: titleLabel)
        self.bringSubview(toFront: textField)
        
        rightView = UIButton(type: .custom)
        rightView.addTarget(self , action: #selector(rightButtonAction), for: .touchUpInside)
        rightView.sizeToFit()
        rightView.isUserInteractionEnabled = false
        self.addSubview(rightView)
        
        buttomLine = UIView()
        buttomLine.backgroundColor = buttomLineColor
        self.addSubview(buttomLine)
        
        errorMessageLabel = UILabel()
        errorMessageLabel.text = ""
        errorMessageLabel.font = errorMessageFont
        errorMessageLabel.textColor = errorMessageTextColor
        errorMessageLabel.sizeToFit()
        self.addSubview(errorMessageLabel)
    }
    
    fileprivate func addConstraints() {
        let size = NSString(string: "a").boundingRect(with: CGSize(width: self.frame.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: titleFont as Any], context: nil).size
        
        var contentSize = CGSize(width: 0, height: 30)
        
        if !canEdit {
            let size =  NSString(string: text ?? "").boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: contentLabel.font as Any], context: nil).size
            if size.height > contentSize.height {
                contentSize = CGSize(width: size.width, height: size.height + 10)
            }
        }
        
        textField.snp.updateConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self).offset(size.height + 5)
            make.height.greaterThanOrEqualTo(30)
        }
        
        contentLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self).offset(size.height + 5)
            make.height.greaterThanOrEqualTo(contentSize.height)
        }
        
        rightView.snp.updateConstraints { (make) in
            if canEdit {
                make.left.equalTo(textField.snp.right).offset(0)
                make.centerY.equalTo(textField)
            }else {
                make.left.equalTo(contentLabel.snp.right).offset(0)
                make.centerY.equalTo(contentLabel)
            }
            make.right.equalTo(self)
            if rightView.imageView?.image == nil && rightView.titleLabel?.text == nil {
                make.width.equalTo(0)
            }else {
                make.width.equalTo(rightView.frame.width).priority(.high)
            }
        }
        
        buttomLine.snp.updateConstraints { (make) in
            if canEdit {
                make.top.equalTo(textField.snp.bottom)
            }else {
                make.top.equalTo(contentLabel.snp.bottom)
            }
            make.height.equalTo(1)
            make.left.right.equalTo(self)
        }
        errorMessageLabel.sizeToFit()
        errorMessageLabel.snp.updateConstraints { (make) in
            make.left.equalTo(textField)
            make.top.equalTo(buttomLine.snp.bottom).offset(5)
            make.height.equalTo(errorMessageLabel.frame.height)
            make.bottom.equalTo(self)
        }
    }
}

// MARK: action
extension InputTextField {
    @objc fileprivate func rightButtonAction() {
        self.rightButtonBlock?()
    }
    @objc fileprivate func textFieldViewChange(textField: UITextField) {
        self.delegate?.textInputValueChange(textInput: textField)
    }
    @objc fileprivate func doneAction(){
        self.endEditing(true)
    }
}

// MARK: TextField Delegate
extension InputTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textInputDidEndEditing(textInput: textField)
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.delegate?.textInputShouldClear(textInput: textField) ?? true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.textInputShouldReturn(textInput: textField) ?? true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.titleLabel.textColor = titleTextColor
        self.buttomLine.backgroundColor = buttomLineColor
        if textField.text?.count ?? 0 > 0 {
            // 有值
        }else {
            if self.type == .begin {
                animationUpdateTitleFrame(type: .reduction)
            }
        }
        return self.delegate?.textInputShouldEndEditing(textInput: textField) ?? true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.titleLabel.textColor = editColor
        self.buttomLine.backgroundColor = editColor
        if textField.text?.count ?? 0 > 0 {
            // 有值
        }else {
            if self.type != .begin {
                animationUpdateTitleFrame(type: .begin)
            }
        }
        return self.delegate?.textInputShouldBeginEditing(textInput: textField) ?? true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textInputDidBeginEditing(textInput: textField)
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.delegate?.textInputDidEndEditing(textField, reason: reason)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.delegate?.textInput(textInput: textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }
}

// MARK: private  method
extension InputTextField {
    fileprivate func animationUpdate() {
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        UIView.animate(withDuration: 0, animations: {
            self.layoutIfNeeded()
        }) { (result ) in
            
        }
    }
    fileprivate func animatePlaceholder(to applyConfiguration: @escaping () -> Void) {
        let duration = 0.3
        UIView.animate(withDuration: duration) {
            applyConfiguration()
        }
    }
    
    func titleSize() -> CGSize {
        return NSString(string: self.titleLabel.text ?? "").boundingRect(with: CGSize(width: self.frame.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: titleFont as Any], context: nil).size
    }
    
    
    
    /// 动画
    ///
    /// - Parameter reduction: 是否需要还原 true 还原 说明已经执行过动画
    func  animationUpdateTitleFrame(type: AnimationType)  {
        self.type = type
        if type == .reduction {
            animatePlaceholder {
                let scale = CGAffineTransform.init(scaleX: 1, y: 1)
                let translation = CGAffineTransform.init(translationX: 0, y: 0)
                self.titleLabel.transform = scale.concatenating(translation)
            }
        }
        if type == .begin {
            animatePlaceholder {
                let size = self.titleSize()
                let scale:CGFloat = 0.8
                //比例缩放
                let scaleTransform = CGAffineTransform.init(scaleX: scale, y: scale)
                // 平移 相加
                let Y = self.titleLabel.frame.minY - 5
                let X = size.width * ((1 - scale)/2)
                let translation = CGAffineTransform.init(translationX: -X, y: -Y)
                
                self.titleLabel.transform = scaleTransform.concatenating(translation)
            }
        }
    }
}
