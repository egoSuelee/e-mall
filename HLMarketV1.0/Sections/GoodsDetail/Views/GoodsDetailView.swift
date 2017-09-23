//
//  GoodsDetailView.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/31.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Kingfisher


enum GoodsDetailViewType {
    case addShopCart
    case shoppingNow
}


class GoodsDetailView: UIView {
    
    var doActionBlock: ((_ count: Int, _ price: String) -> Void)?
    
    var selectedPrice:String?
    var type:GoodsDetailViewType? {
        didSet {
            guard let type = type else {
                return
            }
            switch type {
            case .addShopCart:
                self.doBtn.setTitle("加入购物车", for: .normal)
                self.doBtn.backgroundColor = UIColor.colorFromHex(0xfebf15)
            default:
                self.doBtn.setTitle("立即购买", for: .normal)
                self.doBtn.backgroundColor = UIColor.colorFromHex(0xF02B2B)
            }
        }
    }
    
    fileprivate var count: Int = 1 {
        didSet{
            
            self.selectCountLabel.text = "已选：\(count)" + self.cUnit
            
            guard cGoodsSpecs.count != 0 else {
                return
            }
            
            let priceModel = cGoodsSpecs[0].cSpecPrices
            
            for (index,model) in priceModel.enumerated() {
                if CGFloat(count) < CGFloat(Double(model.cLower)!) {
                    if index == 0 {
                        self.goodsPriceLabel.text = "￥" + self.bOnLine_Price
                        self.selectedPrice = self.bOnLine_Price
                    }else{
                        self.goodsPriceLabel.text = "￥" + priceModel[index-1].cPrice.cgFloatString()
                        self.selectedPrice = priceModel[index-1].cPrice.cgFloatString()
                    }
                }else if CGFloat(count) == CGFloat(Double(model.cLower)!) {
                    self.goodsPriceLabel.text = "￥" + model.cPrice.cgFloatString()
                    self.selectedPrice = model.cPrice.cgFloatString()
                }else {
                    if index == priceModel.count-1 {
                        self.goodsPriceLabel.text = "￥" + model.cPrice.cgFloatString()
                        self.selectedPrice = model.cPrice.cgFloatString()
                    }
                }
            }
        }
    }
    
    fileprivate var bOnLine_Price: String = ""
    
    fileprivate var cUnit: String = ""
    
    fileprivate var cGoodsSpecs=[GoodsSpecsModel]()
    
    lazy var backBtn:UIButton = { [weak self] in
        let btn = HLP_MiniImageSizeBtn.image(scale: 0.7)
        btn.setImage(#imageLiteral(resourceName: "差号"), for: .normal)
        btn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var topBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorFromHex(0xf9f9f9)
        return view
    }()
    
    lazy var bottomBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var goodsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.shadowColor  = UIColor.colorFromHex(0xcdcdcd).cgColor
        imageView.layer.shadowRadius = 3
        imageView.layer.contentsScale = UIScreen.main.scale;
        imageView.layer.shadowOpacity = 0.75
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
        return imageView
    }()
    
    lazy var goodsPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor =  UIColor.colorFromHex(0xF02B2B)
        return label
    }()
    
    lazy var kuCunLabel: UILabel = {
        let label = UILabel()
//        label.text = "库存：300盒"
        return label
    }()
    
    lazy var selectCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var guiGeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorFromHex(0x8b8b8b)
        return label
    }()

    lazy var plusOrReduceLabel:UILabel = {
        let label = UILabel()
        label.text = "购买数量"
        label.textColor = UIColor.colorFromHex(0x8b8b8b)
        return label
    }()
    
    lazy var plusOrReduceBtn:PPNumberButton = {[weak self] in
        let btn = PPNumberButton()
        btn.delegate = self
        btn.borderColor(UIColor.init(gray: 210))
        return btn
    }()
    
    lazy var doBtn:UIButton = { [weak self] in
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = UIColor.colorFromHex(0xF02B2B)
        btn.setTitle("确认", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(doBtnAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    func doBtnAction() -> Void {
        guard let doActionBlock = doActionBlock else {
            return
        }
        if let selectedPrice = self.selectedPrice {
            doActionBlock(count, selectedPrice)
        } else {
            doActionBlock(count, self.bOnLine_Price)
        }
        hide()
    }
    
    func show() -> Void {
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: 0, y: kScreenH/2, width: kScreenW, height: kScreenH/2)
        }
    }
    
    func hide() -> Void {
        UIView.animate(withDuration: 0.5, animations: { 
            self.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kScreenH/2)
        }) { (completion) in
            self.superview?.removeFromSuperview()
        }
    }
    
    init(model:GoodsDetailModel) {
        super.init(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: kScreenH/2))
        self.backgroundColor = UIColor.white
        self.addSubview(topBoxView)
        self.addSubview(bottomBoxView)
        topBoxView.addSubview(goodsImageView)
        topBoxView.addSubview(goodsPriceLabel)
        topBoxView.addSubview(kuCunLabel)
        topBoxView.addSubview(selectCountLabel)
        topBoxView.addSubview(backBtn)
        bottomBoxView.addSubview(guiGeLabel)
        bottomBoxView.addSubview(plusOrReduceLabel)
        bottomBoxView.addSubview(plusOrReduceBtn)
        bottomBoxView.addSubview(doBtn)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        UIApplication.shared.keyWindow?.addSubview(view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        
        view.addGestureRecognizer(tap)
        view.addSubview(self)
        show()
        
        let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
        self.goodsImageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + model.cGoodsImagePath), placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate"))
        self.goodsImageView.contentMode = .scaleAspectFill
        self.goodsImageView.clipsToBounds = true
        self.cUnit = model.cUnit
        self.guiGeLabel.text = "规格: \(model.cSpec)/\(model.cUnit)"
        self.bOnLine_Price = model.bOnLine_Price.cgFloatString()
        self.goodsPriceLabel.text = "￥\(self.bOnLine_Price)"
        
        self.cGoodsSpecs = model.cGoodsSpecs
        
        self.count = Int(Double(model.SelectNum)!)
        self.plusOrReduceBtn.currentValue = model.SelectNum
        self.selectCountLabel.text = "已选：\(self.count)" + self.cUnit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topBoxView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(120)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-WID)
            make.width.height.equalTo(30)
        }
        
        goodsImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WID)
            make.top.equalToSuperview().offset(-25)
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(goodsImageView.snp.height)
        }
        
        goodsPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsImageView.snp.right).offset(WID)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        kuCunLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(goodsPriceLabel)
            make.top.equalTo(goodsPriceLabel.snp.bottom).offset(WID/2)
        }
        
        selectCountLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(goodsPriceLabel)
            make.top.equalTo(kuCunLabel.snp.bottom).offset(WID/2)
        }
        
        //----
        bottomBoxView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topBoxView.snp.bottom)
        }
        
        guiGeLabel.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.left.equalToSuperview().offset(WID)
            make.height.equalTo(50)
        }
        
        
        plusOrReduceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WID)
            make.top.equalTo(guiGeLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(guiGeLabel.snp.height)
        }
        
        plusOrReduceBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(plusOrReduceLabel)
            make.right.equalToSuperview().offset(-WID)
            make.left.equalTo(plusOrReduceLabel.snp.right)
            make.height.equalTo(30)
        }
        
        doBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GoodsDetailView: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view!.isKind(of: GoodsDetailView.self) else {
            return true
        }
        return false
    }
    
}

extension GoodsDetailView:PPNumberButtonDelegate {
    func numberButtonResult(_ numberButton: PPNumberButton, number: String) {
        self.count = Int(number)!
    }
}
