//
//  BMKSearchVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/4/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class BMKSearchVC: BaseViewController {

    var storeLocation:CLLocationCoordinate2D?
    var storeModel:StoreAddressInfoModel?
    
    var dataSource:[BMKPoiInfo]? {
        didSet {
            if let dataSource = dataSource {
                self.dataSource = dataSource.filter {
                    BMKCircleContainsCoordinate($0.pt, storeLocation!, 1500)
                }
                hideHud()
                self.nearByTableView.reloadData()
                searchTF.resignFirstResponder()
            }
        }
    }
    var chooseFinished:((_ bmkPoiInfo:BMKPoiInfo)->Void)?
    var poiSearch:BMKPoiSearch?
    
    lazy var searchTF:UITextField = {[weak self] in
        let tfFrame = CGRect(x: WID, y: 6, width: kScreenW - 2 * WID, height: 40)
        let searchTF = UITextField.init(frame: tfFrame)
        searchTF.layer.backgroundColor = UIColor.white.cgColor
        searchTF.layer.borderColor = UIColor.init(gray: 200).cgColor
        searchTF.layer.borderWidth = 0.5
        searchTF.layer.cornerRadius = 3
        searchTF.layer.masksToBounds = true
        searchTF.leftViewMode = .always
        searchTF.placeholder  = "搜索附近的小区, 写字楼, 餐厅等"
        searchTF.font = UIFont.systemFont(ofSize: 15)
        let iconBtn = UIButton.init(type: .custom)
        iconBtn.setImage(UIImage.init(named: "hlm_search_icon"), for: .normal)
        iconBtn.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        searchTF.leftView = iconBtn
        searchTF.returnKeyType = .search
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(searchContentDidChange(sender:)), for: UIControlEvents.editingChanged)
        return searchTF
        }()
    
    //Mark: --- 懒加载视图
    lazy var nearByTableView:UITableView = {[weak self] in
        let _nearByTableView = UITableView.init(frame: CGRect(x: 0, y: 52, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 52), style: .plain)
        _nearByTableView.backgroundColor = UIColor.colorFromHex(0xF5F5F5)
        _nearByTableView.separatorStyle = .none
        _nearByTableView.dataSource = self
        _nearByTableView.delegate   = self
        _nearByTableView.register(ChooseStoreAddressCell.self, forCellReuseIdentifier: "BMKChooseAddressVCCELLID")
        return _nearByTableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let storeModel = storeModel {
            self.navigationItem.title = storeModel.city
        }
        view.backgroundColor = UIColor.colorFromHex(0xF5F5F5)
        self.view.addSubview(searchTF)
        self.view.addSubview(nearByTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        poiSearch = BMKPoiSearch.init()
        poiSearch?.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        poiSearch?.delegate = nil
    }
    
    func searchContentDidChange(sender:UITextField) {
        if sender.text?.characters.count != 0 {
            let option = BMKNearbySearchOption.init()
            option.location = self.storeLocation!
            option.radius   = 1500
            option.keyword  = sender.text
            option.pageCapacity = 50
            showHud(in: view)
            let flag = poiSearch?.poiSearchNear(by: option)
            if flag! {
                NSLog("检索成功")
            } else {
                NSLog("检索失败")
            }
        }
    }
    
}


extension BMKSearchVC:UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource != nil {
            return (self.dataSource?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BMKChooseAddressVCCELLID", for: indexPath) as! ChooseStoreAddressCell
        
        if let source = self.dataSource {
            let poiInfo = source[indexPath.row]
            cell.bmkModel = poiInfo
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let chooseFinised = self.chooseFinished {
            chooseFinised((self.dataSource?[indexPath.row])!)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension BMKSearchVC:BMKPoiSearchDelegate {
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        switch errorCode {
        case BMK_SEARCH_NO_ERROR:
            self.dataSource = poiResult.poiInfoList as? [BMKPoiInfo]
        default:
            showHint(in: view, hint: "暂无可用地址")
            print(errorCode)
        }
    }
    
    func onGetPoiDetailResult(_ searcher: BMKPoiSearch!, result poiDetailResult: BMKPoiDetailResult!, errorCode: BMKSearchErrorCode) {
        
    }
    
}

extension BMKSearchVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchContentDidChange(sender: textField)
        return true
    }
}




