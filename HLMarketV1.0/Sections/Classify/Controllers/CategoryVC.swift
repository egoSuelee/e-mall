//
//  CategoryVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/7/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON
fileprivate let adImageH = kScreenW * 0.32
class CategoryVC: BaseViewController {

    
    fileprivate var dataArr = Array<ClassifyTypeModel>()
    
    
    lazy var adImage:UIImageView = {[weak self] in
        let adImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: adImageH))
        adImage.image = UIImage.init(named: "hml_category_ads")
        return adImage
        }()
    
    
    lazy var grid:UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(1.5*WID, 2*WID, 1.5*WID, 2*WID)
        layout.itemSize = CGSize.init(width: 4*WID, height: 6*WID)
        layout.minimumLineSpacing = 1.5*WID
        layout.minimumInteritemSpacing = 2*WID
        let rect = CGRect.init(x: 0, y: adImageH, width: kScreenW, height: kScreenH-kStatusBarH-kNavigationBarH-kTabBarH-adImageH)
        let grid = UICollectionView.init(frame: rect, collectionViewLayout: layout)
        grid.register(CategoryCell.self, forCellWithReuseIdentifier: "GOODSCategoryCELLID")
        grid.delegate = self
        grid.dataSource = self
        grid.backgroundColor = UIColor.white
        return grid
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        configureUI()
        getRightTopData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getRightTopData), name: NotiNameOfAfterChooseStore, object: nil)
    }
    
    func configureUI() {
        self.view.addSubview(adImage)
        self.view.addSubview(grid)
    }
   
    func configureSearch() {
        let locationBtn = UIButton.init(type: .custom)
        locationBtn.setImage(UIImage(named: "category_search"), for: .normal)
        locationBtn.sizeToFit()
        locationBtn.frame.size = CGSize(width: 30, height: 30)
        //chooseStoreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        locationBtn.addTarget(self, action: #selector(toSearchVCAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: locationBtn)
    }
    
    func toSearchVCAction() {
        let vc = SearchVC()
        vc.title = "搜索"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getRightTopData() -> Void {
        
        self.dataArr = []
        self.grid.reloadData()
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_Top_Group", method: .post, parameters: ["cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
            
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                
                self.transformJson(json:json)
                
                //数据返回成功 保存plist到沙盒中
                savePlist(data: result as AnyObject,filename: "RightTopData.plist")
                
            }else {
                ///数据返回失败 从沙盒中获取
                if getPlist(filename: "RightTopData.plist").state == true {
                    var resultDict = JSON.null
                    resultDict = JSON(getPlist(filename: "RightTopData.plist").plist)
                    if resultDict != JSON.null {
                        self.transformJson(json: resultDict)
                    }
                }
            }
            
        }) { (error) in
            ///数据返回失败 从沙盒中获取
            if getPlist(filename: "RightTopData.plist").state == true {
                var resultDict = JSON.null
                resultDict = JSON(getPlist(filename: "RightTopData.plist").plist)
                if resultDict != JSON.null {
                    self.transformJson(json: resultDict)
                }
            }
        }
    }
    
    func transformJson(json:JSON) {
        let data = json["dDate"].arrayObject
        
        self.dataArr = ClassifyTypeModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<ClassifyTypeModel>
        
        self.grid.reloadData()
    }
}


extension CategoryVC:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GOODSCategoryCELLID", for: indexPath) as! CategoryCell
        cell.model = dataArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryDetailVC()
        vc.listDataSource = dataArr
        vc.selectedCategoryIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}










