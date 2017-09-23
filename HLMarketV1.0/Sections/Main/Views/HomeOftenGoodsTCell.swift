//
//  HomeOftenGoodsTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/28.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class HomeOftenGoodsTCell: UITableViewCell {
    
    @IBOutlet weak var tagView: HomeOftenGoodsTagView!
    
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsProperty: UILabel!
    
    @IBAction func addShopCartBtnAction(_ sender: Any) {
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
        
        AlamofireNetWork.required(urlString: "/Simple_online/PF_Upload_Shop_cart", method: .post, parameters: ["UserNo": userNo, "cGoodsNo": self.goodsmodel != nil ? self.goodsmodel!.cGoodsNo : self.goodsmodel1!.cGoodsNo, "cStoreNo":UserStoreManager.sharedManager.getStoreNo(),"Num":"1"], success: { (result) in
            
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                
                if self.addGoodsToShopCartBlock != nil {
                    self.addGoodsToShopCartBlock!(true,"加入购物车成功")
                    //发送通知, 让购物车刷新数据
                    
                    //Mark: -- 给购物车添加动画, 让货品跳转至购物车tabbar上
                    //Mark: --- 解决方案1 发送通知请求数据
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: goodsAddedToShopCart), object: self, userInfo: [:])
                    
                    //Mark: --- 解决方案2 发送通知, 用userinfo里传递商品信息, 直接加入数据源
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
    var addGoodsToShopCartBlock: ((_ state: Bool, _ message: String) -> Void)?
    var goodsmodel: ShopCartStyleModel? {
        didSet{
            guard let model = goodsmodel else {
                return
            }
            
            let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
            goodsImageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + model.cGoodsImagePath) as Resource?, placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
            goodsImageView.contentMode = .scaleAspectFill
            goodsImageView.clipsToBounds = true
            goodsName.text  = model.cGoodsName
            
            if (model.bOnLine_Price) != "" {
                goodsPrice.text = "￥" + String.init(format: "%.2f", Float(model.bOnLine_Price)!)
            }else{
                goodsPrice.text = "￥" + String.init(format: "%.2f", Float(model.fNormalPrice)!)
            }
            
            goodsProperty.text = "次数:\(model.purchaseTimes)"
        }
    }
    var goodsmodel1: ShopCartStyleModel? {
        didSet{
            guard let model = goodsmodel1 else {
                return
            }
            
            let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
            goodsImageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + model.cGoodsImagePath) as Resource?, placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
            goodsImageView.contentMode = .scaleAspectFill
            goodsImageView.clipsToBounds = true
            goodsName.text  = model.cGoodsName
            
            if (model.bOnLine_Price) != "" {
                goodsPrice.text = "￥" + String.init(format: "%.2f", Float(model.bOnLine_Price)!)
            }else{
                goodsPrice.text = "￥" + String.init(format: "%.2f", Float(model.fNormalPrice)!)
            }
            
            goodsProperty.text = "月销量:\(model.purchaseTimes)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
