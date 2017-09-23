
//
//  ChooseAddressVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 13/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON


typealias modelVoidClosure = (_ model:AddressUserModel)->Void

private let kChooseAddressVCTableCellID = "kChooseAddressVCTableCellID"
class ChooseAddressVC: UITableViewController {
    
    
    //Mark: --- 选择地址的时候对应的服务门店
    var serviceStoreNo:String?
    
    var userAddressModels:[AddressUserModel]? = []
    var selectedIndex:Int = 0
    var chooseCallBack:modelVoidClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "hlm_add_new_address", highLightImage: "", size: CGSize(width:30, height:30), target: self, action: #selector(AddressManageVC.addAddressAction))
        
        tableView.register(ChooseAddressCell.self, forCellReuseIdentifier: kChooseAddressVCTableCellID)
        tableView.backgroundColor = BGCOLOR
        tableView.separatorStyle  = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(myAddressInfoChanged(notification:)), name: NSNotification.Name(rawValue: addressInfoChanged), object: nil)
        
        
        requestData()
        
    }

    func myAddressInfoChanged(notification:Notification) {
        requestData()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func requestData() {
        self.userAddressModels?.removeAll()
        self.tableView.reloadData()
        
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            AlamofireNetWork.required(urlString: "/Simple_online/Select_User_Address", method: .post, parameters: ["UserNo":userNo,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (results) in
                let json = JSON(results)
                
                if json["resultStatus"] == "1" {
                    let dictArray = json["dDate"].arrayObject
                    for aDict in dictArray! {
                        let aDict:[String:Any] = aDict as! [String : Any]
                        let model = AddressUserModel.init(dict: aDict)
                        self.userAddressModels?.append(model)
                    }
                
                    //排序 -- 按照是否可用, 进行排序
                    var tmpAdressModels = [AddressUserModel]()
                    if let userAddressModels = self.userAddressModels {
                        _ = userAddressModels.map {
                            if $0.cStoreNo != self.serviceStoreNo {
                                tmpAdressModels.append($0)
                            } else {
                                tmpAdressModels.insert($0, at: 0)
                            }
                        }
                        self.userAddressModels = nil
                        self.userAddressModels = tmpAdressModels
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }) { (error) in
                
            }
        }
    }
    
    
    //MARK: 新增收货地址
    func addAddressAction() {
        let addNewAdressVC = AddNewAddressVC2()
        self.navigationController?.pushViewController(addNewAdressVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.userAddressModels {
            return array.count
        } else {
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChooseAddressCell = tableView.dequeueReusableCell(withIdentifier: kChooseAddressVCTableCellID, for: indexPath) as! ChooseAddressCell
        if let array = self.userAddressModels {
            let model = array[indexPath.row]
            cell.model = model
            if serviceStoreNo != model.cStoreNo {
                cell.isAvailable = false
            } else {
                cell.isAvailable = true
            }
        }
        
        if indexPath.row == selectedIndex {
            cell.imageView?.image = UIImage.init(named: "hlm_selected")
        } else { 
            cell.imageView?.image = UIImage.init(named: "hlm_disSelected")
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let array = self.userAddressModels {
            let model = array[indexPath.row]
            if serviceStoreNo != model.cStoreNo {
                self.showHint(in: view, hint: "该地址不在服务门店范围内")
                return
            }
        }
        selectedIndex = indexPath.row
        if let selectClosure = self.chooseCallBack {
            selectClosure((self.userAddressModels?[indexPath.row])!)
        }
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
