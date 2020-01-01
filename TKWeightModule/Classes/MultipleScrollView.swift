//
//  MultipleScrollView.swift
//  TKWeightModule
//
//  Created by 聂子 on 2020/1/1.
//

import Foundation
import TKFoundationModule

public enum ScrollDirection {
    
    case vertical
    
    case horizontal
}

public protocol  MultipleScrollViewProtocol:NSObjectProtocol {

    var scrollView:UIScrollView? { get }
    
    var canScroll: Bool {get set}
    
    var fingerIsTouch: Bool { get set}
}

public class MultipleScrollViewManager {

    private weak var mainContainer: MultipleScrollViewProtocol?
    private var subContainers: NSPointerArray = NSPointerArray.init(options: NSPointerFunctions.Options.weakMemory)
    private(set) weak var currentContainer: MultipleScrollViewProtocol?
    private(set) var mainMaxOffset: CGFloat = 0
    
    
    public init(mianContainer: MultipleScrollViewProtocol, maxOffsetY: CGFloat = 0) {
        let str = String.init(format: "%.5f", maxOffsetY)
        self.mainMaxOffset = CGFloat.init(Float(str) ?? 0)
        self.mainContainer = mianContainer
    }
    public func config(mainContainer: MultipleScrollViewProtocol, maxOffsetY: CGFloat) {
        let str = String.init(format: "%.5f", maxOffsetY)
        self.mainMaxOffset = CGFloat.init(Float(str) ?? 0)
        self.mainContainer = mainContainer
    }
    
}


extension MultipleScrollViewManager {
    // 指定当前正在显示的scrllView
    func addSubScrollView(_ container: MultipleScrollViewProtocol) {
        subContainers.addObject(container)
    }
    func designationCurrentSubContainer(_ container: MultipleScrollViewProtocol)  {
        self.currentContainer = container
    }
}

extension MultipleScrollViewManager {
    func scrollViewDidScroll(container: MultipleScrollViewProtocol, offset: CGFloat) {
        guard let mainContainer = mainContainer, let scrollView = container.scrollView else {
            return
        }
        if container.isEqual(mainContainer) {
            if(scrollView.contentOffset.y) >= mainMaxOffset {
                scrollView.contentOffset = CGPoint.init(x: 0, y: mainMaxOffset)
                if container.canScroll {
                    container.canScroll = false
                    
                    subContainers.allObjects.forEach { (item) in
                        if let item = item as? MultipleScrollViewProtocol {
                            item.canScroll = true
                        }
                    }
                }
            }else {
                if !(mainContainer.canScroll) {
                    scrollView.contentOffset = CGPoint.init(x: 0, y: mainMaxOffset)
                }
                if let currentContainer = currentContainer {
                    if currentContainer.scrollView?.contentSize.height ?? 0 <= currentContainer.scrollView?.frame.size.height ?? 0 {
                        mainContainer.canScroll = true
                    }
                }
            }
            scrollView.showsVerticalScrollIndicator = false
        }
        
        if !container.isEqual(mainContainer){
            if !container.canScroll {
                scrollView.contentOffset = CGPoint.zero
            }
            if scrollView.contentOffset.y <= 0 {
                //                这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
                //                if (!container.fingerIsTouch) {//
                //                    return;
                //                }
                container.canScroll = false
                scrollView.contentOffset = CGPoint.zero
                mainContainer.canScroll = true
                subContainers.allObjects.forEach { (item) in
                    if let item = item as? MultipleScrollViewProtocol {
                        item.canScroll = false
                    }
                }
            }
            scrollView.showsVerticalScrollIndicator = container.canScroll
        }
    }
}

