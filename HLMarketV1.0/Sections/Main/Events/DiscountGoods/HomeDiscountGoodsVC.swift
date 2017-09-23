//
//  HomeDiscountGoodsVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/3.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kHomeDiscountGoodsVCCellID = "kHomeDiscountGoodsVCCellID"


class HomeDiscountGoodsVC: BaseViewController {
    
    fileprivate lazy var tableView: UITableView =  { [weak self] in
        
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 64-10)
        
        let tableView = UITableView(frame: rect, style: UITableViewStyle.plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HomeDiscountGoodsTCell", bundle: nil), forCellReuseIdentifier: kHomeDiscountGoodsVCCellID)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    fileprivate var dataArr = Array<ShopCartStyleModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "折扣商品"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.init(gray: 254)
        
        self.view.addSubview(tableView)
        
        getData()
        
    }
    
    // MARK: -- 获取数据
    func getData() -> Void {
        
        let parameters = ["action":"Activity_goods","cStoreNo":UserStoreManager.sharedManager.getStoreNo()]
        AlamofireNetWork.required(urlString: "/Simple_online/Goods_Strategy_Discount", method: .post, parameters: parameters, success: { (result) in
            
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                
                let data = json["dDate"].arrayObject
                
                let modelArr = ShopCartStyleModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<ShopCartStyleModel>
                
                self.dataArr = self.dataArr + modelArr
                
                self.tableView.reloadData()
                
            }else {
                
                self.showHint(in: self.view, hint: "未搜索到相关信息")
                
            }
            
        }) { (error) in
            
        }
    }
}

// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension HomeDiscountGoodsVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kHomeDiscountGoodsVCCellID) as! HomeDiscountGoodsTCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        let model = dataArr[indexPath.row]
        cell.goodsmodel = model
        
        cell.addGoodsToShopCartBlock = { (state,message) in
            self.showHint(in: self.view, hint: message)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        
        let vc = GoodsDetailVC()
        vc.cGoodsNo = model.cGoodsNo
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.6) {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
}



