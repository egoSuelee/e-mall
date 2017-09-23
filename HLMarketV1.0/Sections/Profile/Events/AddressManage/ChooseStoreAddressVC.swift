//
//  ChooseStoreAddressVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/4/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseStoreAddressVC: BaseViewController {
    
    var chooseFinished:((_ storeInfoModel:StoreAddressInfoModel)->Void)?
    var dataSource:[StoreAddressInfoModel]?
    var type:Int = 0
    lazy var chooseStoreTV:UITableView  = {[weak self] in
        let chooseTV = UITableView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-64))
        chooseTV.delegate = self
        chooseTV.dataSource = self
        chooseTV.register(ChooseStoreAddressCell.self, forCellReuseIdentifier: "ChooseStoreAddressCellID")
        chooseTV.backgroundColor = UIColor.colorFromHex(0xf1f1f1)
        chooseTV.separatorStyle = .none
        return chooseTV
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择服务门店"
        view.addSubview(chooseStoreTV)
        requestData()
    }
    
    func requestData() {
        showHud(in: view)
        AlamofireNetWork.required(urlString: "/Simple_online/Select_All_Store_Address", method: .post, parameters: [:], success: { (result) in
            
            let json = JSON(result)
            print(json)
            if json["resultStatus"] == "1" {
                
                let dictArray = json["dDate"].arrayObject
                
                self.dataSource = StoreAddressInfoModel.mj_objectArray(withKeyValuesArray: dictArray) as? [StoreAddressInfoModel]
                
                DispatchQueue.main.async(execute: {
                    self.chooseStoreTV.reloadData()
                    self.hideHud()
                })
                
            }
        }) { (error) in
            DispatchQueue.main.async(execute: {
                self.showHint(in: self.view, hint: "网络请求出错")
            })

        }
        
    }
    
    
}


extension ChooseStoreAddressVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSourcr = self.dataSource {
            return dataSourcr.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseStoreAddressCellID", for: indexPath) as! ChooseStoreAddressCell
        if let source = self.dataSource {
            let model = source[indexPath.row]
            cell.model = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let chooseFinished = chooseFinished,
            let source = self.dataSource {
            let model = source[indexPath.row]
            chooseFinished(model)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}













