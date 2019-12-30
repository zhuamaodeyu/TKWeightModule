//
//  WaterFlow.swift
//  TKWeightModule
//
//  Created by 聂子 on 2019/4/5.
//

import Foundation


public protocol WaterFlowDataSource: class {
    
}

public protocol WaterFlowDelegate : class {
    
}

public class WaterFlow: UIView {
    public weak var delegate: WaterFlowDelegate?
    public weak var dataSource: WaterFlowDataSource?
}



// MARK: - public method
extension WaterFlow {
    public func reloadData() {
        
    }
}


// MARK: - private method
extension WaterFlow {
    
}

