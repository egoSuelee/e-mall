//
//  HomeSpecialtyGoodsVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/3.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kSearchCellCollectionViewCellID = "kSearchCellCollectionViewCellID"


class HomeSpecialtyGoodsVC: AnimationVC {
    
    fileprivate lazy var collectionView: UICollectionView =  { [weak self] in
        
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 64)
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (kScreenW - 3 * 8)/2.0
        let size = CGSize(width:itemWidth, height:itemWidth*1.5)
        layout.itemSize = size
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let colView = UICollectionView(frame: rect, collectionViewLayout:layout)
        colView.delegate = self
        colView.dataSource = self
        colView.register(ShopCartStyleCell.self, forCellWithReuseIdentifier: kSearchCellCollectionViewCellID)
        colView.backgroundColor = UIColor.white
        return colView
        }()
    
    fileprivate var dataArr = Array<ShopCartStyleModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "特产商品"
        self.view.backgroundColor = UIColor.init(gray: 254)
        
        self.view.addSubview(collectionView)
        
        getData()
        
    }
    
    // MARK: -- 获取数据
    func getData() -> Void {
        
        let parameters = ["action":"Specialty_goods","cStoreNo":UserStoreManager.sharedManager.getStoreNo()]
        AlamofireNetWork.required(urlString: "/Simple_online/Goods_Strategy_Discount", method: .post, parameters: parameters, success: { (result) in
            
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                
                let data = json["dDate"].arrayObject
                
                let modelArr = ShopCartStyleModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<ShopCartStyleModel>
                
                self.dataArr = self.dataArr + modelArr
                
                self.collectionView.reloadData()
                
            }else {
                self.showHint(in: self.view, hint: "未搜索到相关信息")
            }
            
        }) { (error) in
            
        }
    }
}

// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension HomeSpecialtyGoodsVC:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ShopCartStyleCell = collectionView.dequeueReusableCell(withReuseIdentifier: kSearchCellCollectionViewCellID, for: indexPath) as! ShopCartStyleCell
        
        cell.backgroundColor = UIColor.white
        
        //cell.layer.borderColor = UIColor.init(gray: 246).cgColor
        //cell.layer.borderWidth = 1
        //cell.layer.cornerRadius = 6
        //cell.layer.masksToBounds = true
        cell.layer.shadowColor  = UIColor.colorFromHex(0xcdcdcd).cgColor
        cell.layer.shadowRadius = 3
        cell.layer.contentsScale = UIScreen.main.scale;
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        //设置缓存
        cell.layer.shouldRasterize = true
        //设置抗锯齿边缘
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        let model = dataArr[indexPath.row]
        cell.shopCartModel = model
        
        cell.addGoodsToShopCartBlock = { (state,message) in
            self.showHint(in: self.view, hint: message)
        }
        
        cell.addProductClick = {(imageView) -> () in
            self.addProductAnimation(imageView)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        
        let vc = GoodsDetailVC()
        vc.cGoodsNo = model.cGoodsNo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.6) {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
}



