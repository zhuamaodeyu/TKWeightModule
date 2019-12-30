//
//  SliderTextViewViewController.swift
//  TKWeightModule_Example
//
//  Created by 聂子 on 2019/10/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import TKWeightModule

class SliderTextViewViewController: UIViewController {

    private var textView: PlaceHolderTextView!
//    private var sliderView: 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        installTextView()
    }

}

extension SliderTextViewViewController {
    private func installTextView() {
        self.textView = PlaceHolderTextView.init()
        self.textView.frame = CGRect.init(x: 0, y: 100, width: view.frame.width, height: 100)
        self.textView.placehoder = "测试"
        self.textView.placehoderColor = UIColor.red
        self.textView.layer.borderColor = UIColor.black.cgColor
        self.textView.layer.borderWidth = 1
        view.addSubview(textView)
    }
}
