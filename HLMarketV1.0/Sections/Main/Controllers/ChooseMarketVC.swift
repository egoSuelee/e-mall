//
//  ChooseMarketVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/6/21.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

struct MarketModel {
    var cMarketName:String?
    var cMarketIP:String?
    var cMarketNo:String?
    var cMarketDescrible:String?
    var cMarketImage:String?
}

private let kGoldRatio:CGFloat = 0.75

class ChooseMarketVC: BaseViewController {
    
    var dataSource:[MarketModel]?
    var itemDidSelectClick:((_ model: MarketModel)->Void)?
    
    lazy var chooseMarketView:UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width:kScreenW/3, height:(kScreenW/3)/kGoldRatio)
        
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH)
        let collectionView = UICollectionView.init(frame: rect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(gray: 253)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChooseStoreCell.self, forCellWithReuseIdentifier: chooseCollectionViewCellID)
        return collectionView
        
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(gray: 253)
        self.navigationItem.title = "选择门店"
        view.addSubview(chooseMarketView)
        //MARK: --- 重写左边返回按钮事件
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "hlm_back_icon", highLightImage: "", size: CGSize(width:30, height:30), target: self, action: #selector(backToHomeVCAction))
        
        //添加下拉刷新控件
        let refreshHeader = MJRefreshGifHeader { [weak self] in
            self?.requestData()
        }
        
        refreshHeader?.setImages([UIImage.init(named: "icon_hud_1_107x66_")!,
                                  UIImage.init(named: "icon_hud_2_107x66_")!,
                                  UIImage.init(named: "icon_hud_3_107x66_")!,
                                  UIImage.init(named: "icon_hud_4_107x66_")!,
                                  UIImage.init(named: "icon_hud_5_107x66_")!,
                                  UIImage.init(named: "icon_hud_6_107x66_")!,
                                  UIImage.init(named: "icon_hud_7_107x66_")!,
                                  UIImage.init(named: "icon_hud_8_107x66_")!],
                                 duration: 1,
                                 for: MJRefreshStateRefreshing)
        
        chooseMarketView.header = refreshHeader
        chooseMarketView.header.beginRefreshing()

    }
    
    func requestData() {
        let marketApi = DefaultURL + "/Simple_online/Select_MarketIp"
        AlamofireNetWork.required(urlString: marketApi, isUseDefaultURL: false, method: .post, parameters: nil, success: { (result) in
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                self.chooseMarketView.header.endRefreshing()
                let dictArray = json["dDate"].arrayObject
                var tmp = [MarketModel]()
                for aDict in dictArray! {
                    let aDict:[String:String] = aDict as! [String : String]
                    tmp.append(MarketModel.init(cMarketName: aDict["cMarketName"], cMarketIP: aDict["cMarketIp"], cMarketNo: aDict["cMarketNo"], cMarketDescrible: aDict["cMarketDescrible"], cMarketImage: aDict["cMarketImage"]))
                }
                self.dataSource = tmp
                
                DispatchQueue.main.async(execute: { 
                    self.chooseMarketView.reloadData()
                })

            } else {
                self.chooseMarketView.header.endRefreshing()
            }
            
            
        }) { (error) in
            
        }
    }
    
    func backToHomeVCAction() {
//        if userDefault.object(forKey: USERDEFAULT_REDIRECTIP) != nil{
            _ = self.navigationController?.popViewController(animated: true)
            
//        } else {
//            let alertvc = UIAlertController.init(title: "请选择门店", message: nil, preferredStyle: .alert)
//            let okAction = UIAlertAction.init(title: "确定", style: .cancel, handler: { (action) in
//            })
//            alertvc.addAction(okAction)
//            self.present(alertvc, animated: true, completion: nil)
//        }
    }
    
}


extension ChooseMarketVC:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ChooseStoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: chooseCollectionViewCellID, for: indexPath) as! ChooseStoreCell
        guard let dataSource = self.dataSource else {
            return cell
        }
        cell.marketModel = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource else {
            return
        }
        let model:MarketModel = dataSource[indexPath.row]
        if itemDidSelectClick != nil {
            itemDidSelectClick!(model)
        }
        
        let previousIP = userDefault.object(forKey: USERDEFAULT_REDIRECTIP)
        
        userDefault.set(model.cMarketIP, forKey: USERDEFAULT_REDIRECTIP)
        let currentIP = userDefault.object(forKey: USERDEFAULT_REDIRECTIP)
        
        if previousIP == nil {
        //MARK: --- 发送通知告诉购物车, 以及搜索页面刷新数据
            NotificationCenter.default.post(name: NotiNameOfAfterChooseStore, object: self, userInfo: [:])
        } else if previousIP != nil {
            let previousIP = previousIP as! String
            let currentIP  = currentIP as! String
            
            if previousIP != currentIP {
                NotificationCenter.default.post(name: NotiNameOfAfterChooseStore, object: self, userInfo: [:])
            }
        }
        
        //退出登录
        UserAuthManager.sharedManager.cleanUserInfo()
        if UserAuthManager.sharedManager.getUserModel() == nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: userLoginOutActionNoficition), object: self,userInfo: ["UserActionType":HLUserAction.logOut])
        }
        
        //删除缓存数据
        let fileManager = FileManager.default
        let homeUrl = SavePlistfilename(filename: "HomeData1.plist")
        let rightTopUrl = SavePlistfilename(filename: "RightTopData.plist")
        let leftUrl = SavePlistfilename(filename: "LeftArrData.plist")
        let rightUrl = SavePlistfilename(filename: "RightArrData.plist")
        try? fileManager.removeItem(atPath: homeUrl)
        try? fileManager.removeItem(atPath: rightTopUrl)
        try? fileManager.removeItem(atPath: leftUrl)
        try? fileManager.removeItem(atPath: rightUrl)
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}




















