//
//  ChooseStoreVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 24/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kGoldRatio:CGFloat = 0.75
let chooseCollectionViewCellID = "kChooseCollectionViewCellID"

class ChooseStoreVC: BaseViewController {

    var theSelectedIndex:Int = 0
    var selectedCellFrame:CGRect = CGRect.zero
    
    var type2Action: (() -> ())?
    
    var dataSource = [StoreModel]()
    var itemDidSelectClick:((_ model: StoreModel)->Void)?
    
    var type: Int = 0
    
    lazy var chooseStoreView:UICollectionView = {[weak self] in
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
    
    lazy var navTitleView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 64))
        view.backgroundColor = UIColor.appMainColor()
        
        let title = UILabel.init(frame: CGRect(x: 0, y: 20, width: kScreenW, height: 44))
        title.text = "选择门店"
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = UIColor.white
        title.textAlignment = .center
        view.addSubview(title)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(gray: 253)
        self.navigationItem.title = "选择门店"
        //MARK: --- 重写左边返回按钮事件
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "hlm_back_icon", highLightImage: "", size: CGSize(width:30, height:30), target: self, action: #selector(backToHomeVCAction))
        self.view.addSubview(chooseStoreView)
        
        if self.type == 2 {
            chooseStoreView.frame = CGRect(x: 0, y: 64, width: kScreenW, height: kScreenH - 64)
            self.view.addSubview(navTitleView)
        }
        
        //添加下拉刷新控件
        let refreshHeader = MJRefreshGifHeader { [weak self] in
            if self?.type == 0 {
                self?.requestData()
            }else{
                self?.request1Data()
            }
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
        
        chooseStoreView.header = refreshHeader
        chooseStoreView.header.beginRefreshing()
        
    }
    
    
    func backToHomeVCAction() {
        if UserStoreManager.sharedManager.getStoreNo() == "NotSet" {
            let alertvc = UIAlertController.init(title: "请选择门店", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "确定", style: .cancel, handler: { (action) in
            })
            alertvc.addAction(okAction)
            self.present(alertvc, animated: true, completion: nil)
        } else {
           _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.delegate = self
    }
    
    func requestData() {
        AlamofireNetWork.required(urlString: "/Simple_online/Select_All_cStoreNo", method: .post, parameters: [:], success: { (result) in
            self.chooseStoreView.header.endRefreshing()
            
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                
                let dictArray = json["dDate"].arrayObject
                
                self.dataSource = StoreModel.mj_objectArray(withKeyValuesArray: dictArray) as! [StoreModel]
                
                DispatchQueue.main.async(execute: { 
                    self.chooseStoreView.reloadData()
                })
                
            }
        }) { (error) in
            self.chooseStoreView.header.endRefreshing()
        }
        
    }
    
    func request1Data() {
        AlamofireNetWork.required(urlString: "/Simple_online/Select_All_Store_Address", method: .post, parameters: [:], success: { (result) in
            
            self.chooseStoreView.header.endRefreshing()
            
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                
                let dictArray = json["dDate"].arrayObject
                
                self.dataSource = StoreModel.mj_objectArray(withKeyValuesArray: dictArray) as! [StoreModel]
                
                DispatchQueue.main.async(execute: {
                    self.chooseStoreView.reloadData()
                })
                
            }
        }) { (error) in
            self.chooseStoreView.header.endRefreshing()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}

extension ChooseStoreVC:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ChooseStoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: chooseCollectionViewCellID, for: indexPath) as! ChooseStoreCell
        
        cell.model = self.dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model:StoreModel = self.dataSource[indexPath.row]
        UserStoreManager.sharedManager.save(storeNo: model.cStoreNo)
        UserStoreManager.sharedManager.saveStoreName(storeName: model.cStoreName)
        
        if self.type == 2 {
            self.dismiss(animated: false, completion: { 
                self.type2Action!()
            })
            return
        }
        
        if itemDidSelectClick != nil {
            itemDidSelectClick!(model)
        }
        
        let cell:ChooseStoreCell = collectionView.cellForItem(at: indexPath) as! ChooseStoreCell
        
        //可以根据center的中心点确定图片的中心点
        //可以得到图片的大小
        var newFrame = cell.convert(cell.storeImageView.frame, to: self.chooseStoreView)
        newFrame.origin.y -= self.chooseStoreView.contentOffset.y
        
        
        selectedCellFrame = newFrame
        theSelectedIndex = indexPath.row
        
        //MARK: --- 发送通知告诉购物车, 以及搜索页面刷新数据
        NotificationCenter.default.post(name: NotiNameOfAfterChooseStore, object: self, userInfo: [:])
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension  ChooseStoreVC:UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return nil
        }
        
        if operation == .pop {
            return CustomPopAnim(frame:selectedCellFrame)
        }
        
        return nil
    }
    
}
