//
//  ShopCartStyleCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 09/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class ShopCartStyleCell: UICollectionViewCell {
    
    // 上方盒子视图
    lazy var imageBoxView = {UIView.init()}()
    
    // 下方盒子视图
    lazy var asideBoxView = {UIView.init()}()
    
    //下方的下方盒子视图
    lazy var botBoxView = {UIView.init()}()
    
    /// ------ 信息展示视图
    
    lazy var imageView = {() -> UIImageView in
        let view = UIImageView.init()
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var nameLabel = {() -> UILabel in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    lazy var sepLineLabel = {() -> UILabel in
        let label = UILabel.init()
        label.backgroundColor = UIColor.init(gray: 210)
        return label
    }()
    
    lazy var priceLabel = {() -> UILabel in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.appMainColor()
        return label
    }()
    
    lazy var shopcartBtn = {() -> UIButton in
        let btn = HLP_MiniImageSizeBtn.image(scale: 0.7)
        btn.setImage(UIImage.init(named: "hlm_add_shop_cart"), for: UIControlState.normal)
        return btn
    }()
    
    var addGoodsToShopCartBlock: ((_ state: Bool, _ message: String) -> Void)?
    var addProductClick:((_ imageView: UIImageView) -> Void)?
    
    
    func shopcartBtnAction() -> Void {
        
        guard UserAuthManager.sharedManager.getUserModel()?.UserNo != nil else {
            if self.addGoodsToShopCartBlock != nil {
                let alertVC = UIAlertController.init(title: "您还没有登录", message: nil, preferredStyle: .alert)
                let toLogin = UIAlertAction.init(title: "去登录", style: .default, handler: { (action) in
                    let loginVC = LoginViewController()
                    //let window:UIWindow = UIApplication.shared.keyWindow!
                    let rootVC = TabBarController.shareTabBarController
                    rootVC.selectedIndex = 3
                    
                    let profileNavVC:NavigationController = rootVC.childViewControllers.last as! NavigationController
                    profileNavVC.pushViewController(loginVC, animated: true)
                })
                let notNow = UIAlertAction.init(title: "暂不登录", style: .cancel, handler: { (action) in
                    
                })
                alertVC.addAction(toLogin)
                alertVC.addAction(notNow)
                
                TabBarController.shareTabBarController.present(alertVC, animated: true, completion: nil)
                
            }
            return
        }
        
        let userNo = UserAuthManager.sharedManager.getUserModel()!.UserNo
        
        AlamofireNetWork.required(urlString: "/Simple_online/PF_Upload_Shop_cart", method: .post, parameters: ["UserNo": userNo, "cGoodsNo": self.shopCartModel != nil ? self.shopCartModel!.cGoodsNo : self.vADModel!.cGoodsNo, "cStoreNo":UserStoreManager.sharedManager.getStoreNo(),"Num":"1"], success: { (result) in
        
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                
                weak var tempSelf = self
                if self.addGoodsToShopCartBlock != nil {
                    self.addGoodsToShopCartBlock!(true,"加入购物车成功")
                    //发送通知, 让购物车刷新数据
                    
                    //Mark: -- 给购物车添加动画, 让货品跳转至购物车tabbar上
                    //Mark: --- 解决方案1 发送通知请求数据
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: goodsAddedToShopCart), object: self, userInfo: [:])
                    
                    //Mark: --- 解决方案2 发送通知, 用userinfo里传递商品信息, 直接加入数据源
                }
                if tempSelf?.addProductClick != nil {
                    tempSelf?.addProductClick!((tempSelf?.imageView)!)
                }
                
            }else{
                if self.addGoodsToShopCartBlock != nil {
                    self.addGoodsToShopCartBlock!(false,"加入购物车失败")
                }
            }
            
        }, failure: { (error) in
            if self.addGoodsToShopCartBlock != nil {
                self.addGoodsToShopCartBlock!(false,"加入购物车失败")
            }
        })
    }
    
    var shopCartModel:ShopCartStyleModel? {
        didSet {
            if (shopCartModel != nil) {
                let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
                imageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + shopCartModel!.cGoodsImagePath) as Resource?, placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                nameLabel.text  = shopCartModel?.cGoodsName
                
                if (shopCartModel?.bOnLine_Price) != "" {
                    priceLabel.text = "￥" + String.init(format: "%.2f", Float(shopCartModel!.bOnLine_Price)!)
                }else{
                    priceLabel.text = "￥" + String.init(format: "%.2f", Float(shopCartModel!.fNormalPrice)!)
                }
            }
        }
    }
    
    var vADModel:VADModel? {
        didSet {
            if (vADModel != nil) {
                let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
                imageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + vADModel!.cGoodsImagePath), placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                nameLabel.text  = vADModel?.cGoodsName
                
                if (vADModel?.fPrice_SO) != ""{
                    priceLabel.text = "￥" + String.init(format: "%.2f", Float(vADModel!.fPrice_SO)!)
                }else {
                    priceLabel.text = "￥" + String.init(format: "%.2f", Float(vADModel!.fNormalPrice)!)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        imageBoxView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(self.snp.width).offset(-5)
        }
        
        
        asideBoxView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageBoxView.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5))
        }
        
        
        
        //--
        nameLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(asideBoxView).offset(5)
            make.width.equalTo(asideBoxView).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
      
        sepLineLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        //--
        botBoxView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.width.equalTo(asideBoxView).offset(-5)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(asideBoxView.snp.bottom).offset(-5)
        }
        
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.top.lessThanOrEqualToSuperview().offset(5)
            make.bottom.lessThanOrEqualToSuperview()
            //make.centerY.equalToSuperview()
            make.right.equalTo(shopcartBtn.snp.left).offset(-5)
        }
        
        shopcartBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.height.equalToSuperview().offset(5)
            make.centerY.equalToSuperview().offset(2.5)
            make.width.equalTo(shopcartBtn.snp.height)
        }
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        //添加视图
        self.contentView.addSubview(imageBoxView)
        self.contentView.addSubview(asideBoxView)
        
        self.imageBoxView.addSubview(imageView)
        
        self.asideBoxView.addSubview(nameLabel)
        self.asideBoxView.addSubview(botBoxView)
        asideBoxView.backgroundColor = UIColor.init(gray: 252)
        self.nameLabel.addSubview(sepLineLabel)
        
        self.botBoxView.addSubview(priceLabel)
        //self.botBoxView.addSubview(price1Label)
        self.asideBoxView.isUserInteractionEnabled = true
        self.botBoxView.isUserInteractionEnabled = true
        self.botBoxView.addSubview(shopcartBtn)
        self.shopcartBtn.addTarget(self, action: #selector(shopcartBtnAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

