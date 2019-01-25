//
//  TKSliderView.swift
//  TKWeightModule
//
//  Created by 聂子 on 2019/1/25.
//

import Foundation


enum TrackDisableType {
    case normal
    case dottedLine
}

fileprivate  let trackdefaultHeight:CGFloat = 2.0
class SliderView: UIControl {
    fileprivate let defaultLabels = ["",""]
    var trackHeight:CGFloat = trackdefaultHeight
    
    var trackColor: UIColor? = UIColor.gray {
        didSet {
            trackPossibleLayer.backgroundColor = trackColor?.cgColor
        }
    }
    var trackSelectColor: UIColor? = UIColor.yellow {
        didSet {
            trackSelectedLayer.backgroundColor = trackSelectColor?.cgColor
        }
    }
    
    
    var trackDisableColor: UIColor? = UIColor.gray
    var trackDisableType:TrackDisableType? = .normal
    
    // 是否启动事件机制
    var dotsInteractionEnabled: Bool = false
    var cursorCircleRadius:CGFloat = 0.0
    var cruxCircleRadius:CGFloat = 0.0
    
    
    var cruxEnableCount:UInt?{
        willSet {
            if newValue ?? 0 > labels.count {
                debugPrint("place set cruxEnableCount need less than cruxCount")
                return
            }
            if newValue ?? 0 < 1  {
                debugPrint("place set cruxEnableCount need less than 1")
                return
            }
        }
    }
    
    // 当前选中的个数
    private(set) var index:UInt? {
        willSet {
            if index ?? 0 > cruxEnableCount ?? 0 {
                debugPrint("place set index need less than cruxEnableCount")
                return
            }
        }
    }
    
    var cruxDisableColor:UIColor? = UIColor.gray
    var cruxSelectColor:UIColor? = UIColor.yellow
    var cruxSize:CGSize? = CGSize(width:trackdefaultHeight + 2, height: trackdefaultHeight + 2 )
    
    
    var cursorSize:CGSize? = CGSize(width: trackdefaultHeight + 8 , height: trackdefaultHeight + 8)
    var cursorColor:UIColor? = UIColor.yellow
    
    
    var labels: [String] = [] {
        didSet {
            if labels.isEmpty {
                labels = defaultLabels
            }
            createLabels()
            self.setNeedsLayout()
        }
    }
    // label 操作
    var labelFont: UIFont? = UIFont.systemFont(ofSize: 11)
    var labelColor: UIColor? = UIColor.black
    var selectLabelFont: UIFont? = UIFont.systemFont(ofSize: 14)
    var selectLabelColor: UIColor? = UIColor.black
    var disableLabelFont: UIFont? = UIFont.systemFont(ofSize: 11)
    var disableLabelColor: UIColor? = UIColor.gray
    
    // UI private property
    // 私有属性
    fileprivate var trackLayer: CAShapeLayer!
    fileprivate var trackSelectedLayer: CAShapeLayer!
    fileprivate var trackPossibleLayer: CAShapeLayer!
    fileprivate var trackDisableLayer: CAShapeLayer!
    fileprivate var cursorLayer: CAShapeLayer!
    
    fileprivate var animation: Bool = false
    fileprivate var cruxLayers:[CAShapeLayer] = []
    fileprivate var textLayers:[UILabel] = []
    fileprivate let margin:CGFloat = 10.0
    fileprivate var cruxCount:UInt? {
        get {
            if labels.count == 0 {
                return 2
            }
            return UInt(labels.count)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MAKR: layers
extension SliderView {
    fileprivate func installLayers() {
        
        trackLayer = CAShapeLayer()
        trackLayer.backgroundColor = self.backgroundColor?.cgColor
        trackLayer.masksToBounds = true
        trackLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        trackPossibleLayer = CAShapeLayer()
        trackPossibleLayer.backgroundColor = trackColor?.cgColor
        trackPossibleLayer.masksToBounds = true
        trackPossibleLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        trackSelectedLayer = CAShapeLayer()
        trackSelectedLayer.backgroundColor = trackSelectColor?.cgColor
        trackSelectedLayer.masksToBounds = true
        trackSelectedLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        cursorLayer = CAShapeLayer()
        cursorLayer.backgroundColor = cursorColor?.cgColor
        cursorLayer.masksToBounds = true
        
        
        trackDisableLayer = CAShapeLayer()
        trackDisableLayer.masksToBounds = true
        trackDisableLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.layer.addSublayer(trackLayer)
        trackLayer.addSublayer(trackPossibleLayer)
        trackLayer.addSublayer(trackDisableLayer)
        trackLayer.addSublayer(trackSelectedLayer)
    }
    // 创建label
    fileprivate func createLabels() {
        // 需要删除一些不需要的东西多余的控件
        if textLayers.count > labels.count {
            for (index, label) in textLayers.enumerated() {
                if index > labels.count {
                    label.removeFromSuperview()
                    textLayers.remove(at: index)
                }
            }
        }
        
        if cruxLayers.count > labels.count {
            for (index, layer) in cruxLayers.enumerated() {
                if index > labels.count {
                    layer.removeFromSuperlayer()
                    cruxLayers.remove(at: index)
                }
            }
        }
        
        cursorLayer.removeFromSuperlayer()
        
        for (index, text) in self.labels.enumerated() {
            if index < self.textLayers.count {
                // 判断是不是最后一个
                let label = self.textLayers[index]
                label.text = text
                if index == self.labels.count - 1 {
                    label.textAlignment = .right
                }else {
                    label.textAlignment = .center
                }
            }else {
                let label = UILabel()
                label.text = text
                label.numberOfLines = 0
                label.textAlignment = .center
                if (index == 0) {
                    label.textAlignment = .left
                }else if(index == labels.count - 1) {
                    label.textAlignment = .right
                }
                label.font = self.labelFont
                label.textColor = self.labelColor
                label.sizeToFit()
                
                textLayers.append(label)
                self.addSubview(label)
                
                let layer = createCrux()
                cruxLayers.append(layer)
                self.layer.addSublayer(layer)
            }
        }
        layer.addSublayer(cursorLayer)
    }
    
    // 创建关键点
    fileprivate func createCrux() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.masksToBounds = true
        return layer
    }
}

extension SliderView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLayersAnimated(animation: animation)
    }
    
    fileprivate func layoutLayersAnimated(animation: Bool) {
        trackLayer.position = CGPoint(x: margin, y: 30)
        trackLayer.bounds = CGRect(x: 0, y: 0, width: self.frame.width - 2 * margin , height: trackHeight)
        trackLayer.cornerRadius = trackHeight / 2
        
        let maxTextWidth = trackLayer.frame.size.width / CGFloat(textLayers.count - 1)
        
        // 计算text frame
        for (index ,label) in textLayers.enumerated() {
            var X:CGFloat = 0.0
            let Y = trackLayer.frame.maxY + margin
            
            // 设置当前选中的位置
            if self.index ?? 0 >= 0 {
                if self.index! < textLayers.count  {
                    if index != self.index! {
                        label.font = self.labelFont
                        label.textColor = self.labelColor
                    }else {
                        label.font = self.selectLabelFont
                        label.textColor = self.selectLabelColor
                    }
                }
            }
            
            let size = label.sizeThatFits(CGSize(width: maxTextWidth / 4 * 3, height: 0))
            if index == 0 {
                X = trackLayer.frame.minX
            }else if (index == textLayers.count - 1) {
                X = trackLayer.frame.maxX - size.width
            }else {
                X = trackLayer.frame.minX +  maxTextWidth * CGFloat(index) - size.width / 2
            }
            label.frame = CGRect(x: X, y: Y, width: size.width, height: size.height)
        }
        
        // 计算crux frame
        for (index, item) in cruxLayers.enumerated() {
            var X = trackLayer.frame.minX + maxTextWidth * CGFloat(index) - (cruxSize?.width)! / 2.0
            let Y = trackLayer.frame.midY - (cruxSize?.height)! / 2.0
            item.cornerRadius = cruxCircleRadius
            if index == 0 {
                X = trackLayer.frame.minX
            }else if(index == cruxLayers.count - 1) {
                X = trackLayer.frame.maxX - (cruxSize?.width ?? 0)
            }
            // 设置可可选的大小  默认全部可选
            if cruxEnableCount ?? 0 > 0 {
                if index < Int(cruxEnableCount ?? 0) {
                    item.backgroundColor = trackColor?.cgColor
                }else {
                    item.backgroundColor = cruxDisableColor?.cgColor
                }
            }else {
                item.backgroundColor = trackColor?.cgColor
            }
            item.frame = CGRect(x: X, y: Y, width: (cruxSize?.width)!, height: (cruxSize?.height)!)
        }
        
        // trackPossibleLayer frame
        if  cruxEnableCount ?? 0 > 0 {
            trackPossibleLayer.position = CGPoint(x: 0, y: 0)
            trackPossibleLayer.bounds = CGRect(x: 0, y: 0, width: maxTextWidth * CGFloat(cruxEnableCount! - 1), height: trackLayer.frame.height)
            trackDisableLayer.position = CGPoint(x: trackPossibleLayer.frame.maxX, y: trackPossibleLayer.position.y)
            trackDisableLayer.bounds = CGRect(x: 0, y: 0, width: trackLayer.frame.maxX - trackPossibleLayer.frame.maxX, height: trackLayer.frame.size.height)
            // 是否是虚线
            if trackDisableType == .normal {
                trackDisableLayer.backgroundColor = trackDisableColor?.cgColor
                trackDisableLayer.path = nil
            }else {
                trackDisableLayer.strokeColor = trackDisableColor?.cgColor
                trackDisableLayer.fillColor = UIColor.clear.cgColor
                trackDisableLayer.lineWidth = trackDisableLayer.frame.height
                trackDisableLayer.lineJoin = kCALineJoinRound
                trackDisableLayer.lineDashPattern = [2,2]
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: trackDisableLayer.frame.width, y: 0))
                trackDisableLayer.path = path
            }
        } else {
            trackPossibleLayer.position = CGPoint(x: 0, y: 0)
            trackDisableLayer.position = CGPoint(x: trackPossibleLayer.frame.maxX, y: trackPossibleLayer.position.y)
            trackPossibleLayer.bounds = trackLayer.bounds
            trackDisableLayer.bounds = CGRect.zero
        }
        
        // 设置 index
        if index ?? 0 > 0 {
            if index! < cruxEnableCount ?? 1 {
                for (i, layer) in cruxLayers.enumerated() {
                    if i < index! {
                        layer.backgroundColor = cruxSelectColor?.cgColor
                    }else {
                        if i > index! &&  i < cruxEnableCount ?? 0 {
                            layer.backgroundColor = trackColor?.cgColor
                        }else {
                            layer.backgroundColor = cruxDisableColor?.cgColor
                        }
                    }
                }
                let layer = cruxLayers[Int(index!)]
                let cursorX = layer.frame.minX - (cursorSize?.width)! / 2.0
                let cursorY = layer.frame.midY - (cursorSize?.height)! / 2.0
                cursorLayer.frame = CGRect(x: cursorX, y: cursorY, width: (cursorSize?.width)!, height: (cursorSize?.height)!)
            }
            
            trackSelectedLayer.position = CGPoint(x: -(trackLayer.frame.width - cursorLayer.frame.minX), y: -2)
            trackSelectedLayer.bounds = CGRect(x: 0, y: 0, width: trackLayer.frame.width, height: trackLayer.frame.size.height + 4)
        } else {
            trackSelectedLayer.position = CGPoint(x: -trackLayer.frame.width, y: -2)
            trackSelectedLayer.bounds = CGRect(x: 0, y: 0, width: trackLayer.frame.width, height: trackLayer.frame.size.height + 4)
            let cursorX = trackLayer.frame.minX - (cursorSize?.width)! / 2.0
            let cursorY = trackLayer.frame.midY - (cursorSize?.height)! / 2.0
            cursorLayer.frame = CGRect(x: cursorX, y: cursorY, width: (cursorSize?.width)!, height: (cursorSize?.height)!)
        }
        cursorLayer.cornerRadius = cursorCircleRadius
        
    }
}

// MARK: public method
extension SliderView {
    public func set(index: UInt, animation: Bool) {
        var currentIndex = index
        if index > cruxEnableCount ?? 1 {
            currentIndex = cruxEnableCount ?? 1
        }
        self.index = currentIndex
        self.animation = animation
        self.setNeedsLayout()
    }
}

// MARK: Touchs
extension SliderView {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if labels == defaultLabels {
            return false
        }
        
        // 1. 获取当前事件点, 判断是否可以触发事件
        let startTouchPosition = touch.location(in: self)
        let trackFrame =  trackLayer.frame
        
        // 可选区域
        let padding: CGFloat = 30
        let effectFrame = CGRect(x:trackLayer.position.x , y: trackLayer.position.y - padding, width: trackFrame.width, height: trackFrame.height + padding * 2)
        
        // 带有事件
        if cursorLayer.frame.contains(startTouchPosition) {
            return true
        }
        if effectFrame.contains(startTouchPosition) {
            if effectFrame.contains(startTouchPosition) {
                withoutCAAnimation {
                    self.cursorLayer.frame = CGRect(x: startTouchPosition.x,
                                                    y: self.cursorLayer.frame.minY,
                                                    width: self.cursorLayer.frame.width,
                                                    height: self.cursorLayer.frame.height)
                    for (index ,layer) in cruxLayers.enumerated() {
                        if layer.frame.midX < startTouchPosition.x {
                            layer.backgroundColor = cruxSelectColor?.cgColor
                        }else {
                            if index < Int(self.cruxEnableCount ?? 0) {
                                layer.backgroundColor = trackColor?.cgColor
                            }else {
                                layer.backgroundColor = cruxDisableColor?.cgColor
                            }
                        }
                        let trackSelectedpositionX = -(trackLayer.frame.width - (startTouchPosition.x - trackLayer.frame.minX))
                        let trackSelectedPositionY = trackSelectedLayer.position.y
                        self.trackSelectedLayer.position = CGPoint(x: trackSelectedpositionX, y: trackSelectedPositionY)
                    }
                }
            }
            return true
        }
        return false
    }
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 进行具体的连续事件处理模式
        let position = touch.location(in: self)
        let trackFrame = trackLayer.frame
        // 有效区域
        let padding: CGFloat = 30
        let effectFrame = CGRect(x:trackLayer.position.x , y: trackLayer.position.y - padding, width: trackFrame.width, height: trackFrame.height + padding * 2)
        
        if effectFrame.contains(position) {
            withoutCAAnimation {
                self.cursorLayer.frame = CGRect(x: position.x,
                                                y: self.cursorLayer.frame.minY,
                                                width: self.cursorLayer.frame.width,
                                                height: self.cursorLayer.frame.height)
                for (index ,layer) in cruxLayers.enumerated() {
                    if layer.frame.midX < position.x {
                        layer.backgroundColor = cruxSelectColor?.cgColor
                    }else {
                        if index < Int(self.cruxEnableCount ?? 0) {
                            layer.backgroundColor = trackColor?.cgColor
                        }else {
                            layer.backgroundColor = cruxDisableColor?.cgColor
                        }
                    }
                    let trackSelectedpositionX = -(trackLayer.frame.width - (position.x - trackLayer.frame.minX))
                    let trackSelectedPositionY = trackSelectedLayer.position.y
                    self.trackSelectedLayer.position = CGPoint(x: trackSelectedpositionX, y: trackSelectedPositionY)
                }
            }
        }
        return true
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        // 根据结束点，然后判断是否需要触发更改事件
        let endTouchPosition = touch?.location(in: self)
        let trackPossibleFrame = trackPossibleLayer.frame
        
        // 判断点与点之间的距离最近的
        if endTouchPosition == nil {
            self.setNeedsLayout()
            return
        }
        // 超出了可选区域的
        if (endTouchPosition?.x)! > trackPossibleFrame.maxX {
            self.index = UInt(cruxEnableCount ?? 0) - 1
            animation = true
            self.setNeedsLayout()
            // 发送事件
            self.sendActions(for: .valueChanged)
            self.sendActions(for: .touchCancel)
            return
        }
        
        var minDistrance:CGFloat = 10000
        var minIndex = 0
        for (index,layer) in cruxLayers.enumerated() {
            let distrance =  SliderView.distance(point1: endTouchPosition!, point2: CGPoint(x: layer.frame.midX, y: layer.frame.midY))
            if distrance < minDistrance {
                minDistrance = distrance
                minIndex = index
            }
        }
        
        if minIndex >= cruxEnableCount ?? 0 {
            minIndex = Int(UInt(cruxEnableCount ?? 0) - 1)
        }
        if minIndex == (index ?? 0) {
            self.setNeedsLayout()
            return
        }else {
            // 更新到指定的位置
            self.index = UInt(minIndex)
            animation = true
            self.setNeedsLayout()
            // 发送事件
            self.sendActions(for: .valueChanged)
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        // 取消
        debugPrint("cancelTracking")
    }
}

// MARK: TexTLayer
extension SliderView {
    fileprivate func withoutCAAnimation(block: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        block()
        CATransaction.commit()
    }
}

extension SliderView {
    // 计算两点之间的距离
    fileprivate class func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
}

