//
//  MoreGoodsVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kMoreGoodsCellCollectionViewCellID = "kMoreGoodsCellCollectionViewCellID"

class MoreGoodsVC: BaseViewController {
    
    var data: (title:String,fage:String)?
    
    fileprivate lazy var collectionView: UICollectionView =  { [weak self] in
        
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kTabBarH)
        
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
        colView.register(ShopCartStyleCell.self, forCellWithReuseIdentifier: kMoreGoodsCellCollectionViewCellID)
        colView.backgroundColor = UIColor.white
        return colView
        }()
    
    fileprivate var dataArr = Array<VADModel>()
    
    fileprivate var currentPage = 1
    
    fileprivate var isLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.data?.title ?? "更多"
        
        self.view.backgroundColor = UIColor.init(gray: 254)
        
        self.view.addSubview(collectionView)
        
        getMoreGoodsDate(fage: self.data?.fage ?? "1", pages: currentPage)
        
    }
    
    // MARK: -- 获取数据
    func getMoreGoodsDate(fage: String, pages: Int) -> Void {
        
        let parameters = ["cPloyTypeNo":fage,"Number_of_pages":"\(pages)","cStoreNo":UserStoreManager.sharedManager.getStoreNo()]
        
        AlamofireNetWork.required(urlString: "/Simple_online/Strategy_More_Goods", method: .post, parameters: parameters, success: { (result) in
            
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                
                let data = json["dDate"].arrayObject
                
                let modelArr = VADModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<VADModel>
                
                self.dataArr = self.dataArr + modelArr
                
                self.collectionView.reloadData()
                
                self.isLoad = true
                
            }else {
                
                if self.currentPage == 1 {
                    self.showHint(in: self.view, hint: "未搜索到相关信息")
                }else{
                    self.isLoad = false
                    self.currentPage -= 1
                }
                
            }
            
        }) { (error) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension MoreGoodsVC:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ShopCartStyleCell = collectionView.dequeueReusableCell(withReuseIdentifier: kMoreGoodsCellCollectionViewCellID, for: indexPath) as! ShopCartStyleCell
        
        cell.backgroundColor = UIColor.white
        
        cell.layer.borderColor = UIColor.init(gray: 246).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        
        let model = dataArr[indexPath.row]
        cell.vADModel = model
        
        cell.addGoodsToShopCartBlock = { (state,message) in
            self.showHint(in: self.view, hint: message)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        
        let vc = GoodsDetailVC()
        vc.cGoodsNo = model.cGoodsNo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if  collectionView.cellForItem(at: IndexPath(row: dataArr.count - 3, section: 0)) != nil && self.isLoad {
            self.isLoad = false
            currentPage += 1
            getMoreGoodsDate(fage: self.data?.fage ?? "1", pages: currentPage)
        }
    }
    
}



