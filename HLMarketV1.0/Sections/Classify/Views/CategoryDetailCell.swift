//
//  CategoryDetailCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/7/25.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

let kHGoodsCellHeight = (kScreenH-kStatusBarH-kNavigationBarH)/6 + _1pxWidth
fileprivate let baseTextSize = kHGoodsCellHeight/10
fileprivate let scaleRate:CGFloat = 0.5


class CategoryDetailCell: UITableViewCell {

    
    let margin:CGFloat = 8
    var wrapper  = UIView.init()
    lazy var sepLine:UIView = {[weak self] in
        let view = UIView.init()
        view.backgroundColor = UIColor.colorFromHex(0xececec)
        return view
        }()
    var leftBox  = UIView.init()
    lazy var goodsImageView:UIImageView = {[weak self] in
        let goodsImage = UIImageView.init()
        goodsImage.backgroundColor = UIColor.sharedImageColor()
        return goodsImage
    }()
    
    var rightBox = UIView.init()
    var rightContainer = UIView.init()
    
    var rightTopBox = UIView.init()
    var rightBotBox = UIView.init()
    
    var rightBotLeftWrapper = UIView.init()
    var rightBotRightWrapper = UIView.init()
    
    var addGoodsToShopCartBlock: ((_ state: Bool, _ message: String) -> Void)?
    
    //Mark: --- 添加商品至购物车按钮
    lazy var addShopCart:UIButton = {[weak self] in
        let btn = HLP_MiniImageSizeBtn.image(scale: 0.65)
        btn.setImage(UIImage.init(named: "hlm_add_shop_cart"), for: .normal)
        btn.addTarget(self, action: #selector(addGoodsToShopCart), for: .touchUpInside)
        return btn
        }()
    
    var shopCartModel:ShopCartStyleModel? {
        didSet {
            if let shopCartModel = shopCartModel {
                let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
                goodsImageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + shopCartModel.cGoodsImagePath) as Resource?, placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
                goodsImageView.contentMode = .scaleAspectFill
                goodsImageView.clipsToBounds = true
                goodsNameLabel.text  = shopCartModel.cGoodsName
                goodsFeatureLabel.text = shopCartModel.cFeatureTags
                
                wuliuLabel.setTitle(shopCartModel.cMarketingTags, for: .normal)
                
                let rect = wuliuLabel.titleLabel?.text?.boundingRect(with: CGSize(width: kScreenW ,height: self.frame.height*0.4), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:wuliuLabel.titleLabel!.font], context: nil)
                
                self.wuliuLabelFrameWidth = (rect?.width ?? 0.0) + 35
                
                var priceLabelText = ""
                if (shopCartModel.bOnLine_Price) != "" {
                    priceLabelText = String.init(format: "%.2f", Float(shopCartModel.bOnLine_Price)!)
                    
                } else{
                    priceLabelText = String.init(format: "%.2f", Float(shopCartModel.fNormalPrice)!)
                }
                let priceLen = priceLabelText.characters.count
                priceLabelText = "￥"+priceLabelText + "/\(shopCartModel.cSpec)"+"/\(shopCartModel.cUnit)"
                let titleLen = 1
                
                //让价格显示的更加突出一些
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: priceLabelText)
                attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: baseTextSize*2*scaleRate),range: NSMakeRange(0,titleLen))
                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHex(0xF02B2B),range: NSMakeRange(0,titleLen))
                attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: baseTextSize*3*scaleRate),range: NSMakeRange(titleLen,priceLen))
                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHex(0xF02B2B),range: NSMakeRange(titleLen, priceLen))
                attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: baseTextSize*2*scaleRate),range: NSMakeRange(priceLen+titleLen,priceLabelText.characters.count-titleLen-priceLen))
                attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHex(0x7d7d7d),range: NSMakeRange(priceLen+titleLen,priceLabelText.characters.count-titleLen-priceLen))
                
                self.priceLabel.attributedText = attributeString

                
                layoutIfNeeded()
            }
        }
    }
    
    var wuliuLabelFrameWidth: CGFloat = 0.0

    
    //Mark: --- 信息源
   
    lazy var goodsNameLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0x383838)
        label.font = UIFont.systemFont(ofSize: baseTextSize*3*scaleRate)        
        return label
        }()
    lazy var goodsFeatureLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0x7d7d7d)
        label.font = UIFont.systemFont(ofSize: baseTextSize*2*scaleRate)
        return label
        }()
    lazy var wuliuLabel:UIButton = {[weak self] in
        let label = UIButton.init()
        label.setImage(UIImage.init(named: "时间"), for: .normal)
        label.setTitleColor(UIColor.colorFromHex(0x7d7d7d), for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: baseTextSize*2*scaleRate)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.colorFromHex(0x7d7d7d).cgColor
        label.layer.borderWidth = 1
        return label
        }()
    lazy var priceLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0xF02B2B)
        label.font = UIFont.systemFont(ofSize: baseTextSize*3*scaleRate)
        return label
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    func setupUI() {
        
        contentView.addSubview(wrapper)
        contentView.addSubview(sepLine)
        
        _ = [leftBox, rightBox].map {
            wrapper.addSubview($0)
        }
        leftBox.addSubview(goodsImageView)
        rightBox.addSubview(rightContainer)
        _ = [rightTopBox, rightBotBox].map {
            rightContainer.addSubview($0)
            
        }
        rightTopBox.addSubview(goodsNameLabel)
        rightTopBox.addSubview(goodsFeatureLabel)
        
        _ = [rightBotLeftWrapper, rightBotRightWrapper].map {
            rightBotBox.addSubview($0)
           
        }
        rightBotLeftWrapper.addSubview(wuliuLabel)
        rightBotLeftWrapper.addSubview(priceLabel)
        
        rightBotRightWrapper.addSubview(addShopCart)
    }
    
    
    func addGoodsToShopCart() {
        
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
        
        AlamofireNetWork.required(urlString: "/Simple_online/PF_Upload_Shop_cart", method: .post, parameters: ["UserNo": userNo, "cGoodsNo": (self.shopCartModel?.cGoodsNo)!, "cStoreNo":UserStoreManager.sharedManager.getStoreNo(),"Num":"1"], success: { (result) in
            
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
    
    override func layoutSubviews() {
        wrapper.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: margin, left: margin, bottom: margin + _1pxWidth, right: margin))
        }
        
        sepLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.height.equalTo(_1pxWidth)
        }
        
        leftBox.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(leftBox.snp.height)
        }
        
        goodsImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        
        
        rightBox.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(leftBox.snp.right)
        }
        rightContainer.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        rightTopBox.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(rightBotBox.snp.height)
            make.bottom.equalTo(rightBotBox.snp.top)
        }
        goodsNameLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        goodsFeatureLabel.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        rightBotBox.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(rightTopBox.snp.height)
            make.top.equalTo(rightTopBox.snp.bottom)
        }
        rightBotLeftWrapper.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        wuliuLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(margin/4)
            make.width.equalTo(self.wuliuLabelFrameWidth)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(margin/2)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        rightBotRightWrapper.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        addShopCart.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.width.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
