//
//  ViewController.swift
//  TKWeightModule
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit
import TKWeightModule

class ViewController: UIViewController {

    private var tableView: UITableView!
    private var dataSources:[String] = []


//    private var floatingButton: FloatingButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        view.addSubview(tableView)
        test()
    }

    private func test() {
        dataSources.append("FloatingButton")
        dataSources.append("TKSliderView,PlaceHolderTextView,")
        dataSources.append("TKTextField,TKErrorTextFiled,TKTextField")
        dataSources.append("WaterFlow")
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil  {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            cell?.textLabel?.text = dataSources[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:

            break
        case 1:
            self.navigationController?.pushViewController(SliderTextViewViewController.init(), animated: true)
        case 2:
            self.navigationController?.pushViewController(TextFieldViewController.init(), animated: true)
        case 3:
            self.navigationController?.pushViewController(WaterFlowViewController.init(), animated: true)
        default:
            break
        }
    }
}
