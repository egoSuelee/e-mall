//
//  GoodsControlView.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 10/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

enum GoodsControlType {
    case counts
    case detailCounts
    case plusOrReduce
    case delete
}
@objc protocol GoodsControlViewDelegate {
    func numberButtonResult(_ numberButton: PPNumberButton, number: String)
    @objc optional func deleteItemAction()
}

private let kGRadio:CGFloat = 0.618

class GoodsControlView: UIView {
    
    var delegate:GoodsControlViewDelegate?
    
    var type:GoodsControlType = .counts
    
    var model:GoodsControlModel? {
        didSet {
            let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
            
            goodsAvtarView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + model!.avtarImage), placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
            goodsAvtarView.contentMode = .scaleAspectFill
            goodsAvtarView.clipsToBounds = true
            titleLabel.text = "品名:\((model?.title)!)"
            
            //priceLabel.text = "价格:\((model?.price)!.cgFloatString())"
            
            let priceText = "¥\((model?.price)!.cgFloatString())"
            let titleLen = 1
            //让价格显示的更加突出一些
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: priceText)
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13),range: NSMakeRange(0,titleLen))
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHex(0xF02B2B),range: NSMakeRange(0,titleLen))
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16),range: NSMakeRange(titleLen,priceText.characters.count-titleLen))
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHex(0xF02B2B),range: NSMakeRange(titleLen, priceText.characters.count-titleLen))
            self.priceLabel.attributedText = attributeString
            
            switch type {
            case .counts:
                countLabel.text = "x \((model?.count)!.cgFloatString())"
            case .detailCounts:
                let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
                let str : NSAttributedString = NSAttributedString(string: "x \((model?.count)!.cgFloatString())", attributes: [ NSBackgroundColorAttributeName : UIColor.lightText,NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 15)])
                let str1 : NSAttributedString = NSAttributedString(string: "\n实送:x \((model?.realcount)!.cgFloatString())", attributes: [NSForegroundColorAttributeName : UIColor.red, NSFontAttributeName : UIFont.systemFont(ofSize: 15)])
                
                attributedStrM.append(str)
                attributedStrM.append(str1)
                countLabel.attributedText = attributedStrM
            case .plusOrReduce:
                plusOrReduceBtn.currentValue = (model?.count)!.intString()
            default:
                break
            }
        }
    }
    
    lazy var leftBoxView = {UIView.init()}()
    lazy var rightBoxView = {UIView.init()}()
    
    //左边视图元素
    lazy var goodsAvtarView = {() -> UIImageView in
        let imageview = UIImageView.init()
        imageview.layer.cornerRadius = 3
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    
    lazy var titleLabel = {() -> UILabel in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    lazy var priceLabel = {() -> UILabel in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    //右边视图元素
    /*
     这个视图应该是加减控制按钮的空间视图, 可以自带加减方法,
     并在每次点击之后可以返回一个数值,
     当数值的值为1的时候, 左边的按钮应该处于不可点击状态
     */
    lazy var plusOrReduceBtn:PPNumberButton = { [weak self] in
        let btn = PPNumberButton.init()
        btn.delegate = self
        btn.borderColor(UIColor.init(gray: 210))
        return btn
    }()
    
    lazy var countLabel = {() -> UILabel in
        let label = UILabel.init()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var deleteBtn: UIButton = { [weak self] in
        let btn = UIButton.init()
        btn.setTitle("删除", for: .normal)
        btn.titleLabel?.font = font(14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(deleteItemAction), for: .touchUpInside)
        
        //Mark: -- 这里定制按钮的样式
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        //btn.layer.borderWidth = 1
        //btn.layer.borderColor = UIColor.appMainColor().cgColor
        btn.layer.backgroundColor = UIColor.appTextMainColor().cgColor
        
        
        btn.addTarget(self, action: #selector(deleteItemAction), for: .touchUpInside)
        
        return btn
    }()
    
    func deleteItemAction() {
        if let delegate = self.delegate {
            delegate.deleteItemAction!()
        }
        
    }
    
    
    init(frame: CGRect, type:GoodsControlType) {
        super.init(frame: frame)
        
        //self.layer.backgroundColor = UIColor.white.cgColor
        //self.layer.borderColor = UIColor.init(gray: 252).cgColor
        //self.layer.borderWidth = 0.5
        
        self.addSubview(leftBoxView)
        self.addSubview(rightBoxView)
        
        leftBoxView.addSubview(goodsAvtarView)
        leftBoxView.addSubview(titleLabel)
        leftBoxView.addSubview(priceLabel)
        
        rightBoxView.addSubview(countLabel)
        self.type = type
        switch type {
        case .counts,.detailCounts:
            rightBoxView.addSubview(countLabel)
            break
        /*
        case .delete:
            rightBoxView.addSubview(deleteBtn)
        */
        default:
            rightBoxView.addSubview(plusOrReduceBtn)
            rightBoxView.addSubview(deleteBtn)
        }
    }
    
    //布局
    override func layoutSubviews() {
        let kGoodsControlViewMargin:CGFloat = 5
        leftBoxView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(kGoodsControlViewMargin)
            make.bottom.equalTo(self).offset(-kGoodsControlViewMargin)
            make.width.equalTo(self.snp.width).offset(2 * kGoodsControlViewMargin).multipliedBy(kGRadio)
        }
        
        
        goodsAvtarView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(kGoodsControlViewMargin)
            make.bottom.equalToSuperview().offset(-kGoodsControlViewMargin)
            make.width.equalTo(goodsAvtarView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kGoodsControlViewMargin)
            make.left.equalTo(goodsAvtarView.snp.right).offset(kGoodsControlViewMargin)
            make.right.equalTo(rightBoxView.snp.right).offset(kGoodsControlViewMargin)
            make.height.equalTo(goodsAvtarView.snp.height).multipliedBy(0.4)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(titleLabel)
            make.bottom.equalTo(goodsAvtarView.snp.bottom)
        }
        
        rightBoxView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(leftBoxView)
            make.left.equalTo(leftBoxView.snp.right).offset(kGoodsControlViewMargin)
            make.right.equalTo(self).offset(-kGoodsControlViewMargin)
        }
        
        switch type {
        case .counts:
            countLabel.snp.makeConstraints { (make) in
                make.left.equalTo(rightBoxView).offset(kGoodsControlViewMargin)
                make.right.bottom.equalToSuperview().offset(-kGoodsControlViewMargin)
                make.height.equalTo(20)
            }
        case .detailCounts:
            countLabel.snp.makeConstraints { (make) in
                make.left.equalTo(rightBoxView).offset(kGoodsControlViewMargin)
                make.right.bottom.equalToSuperview().offset(-kGoodsControlViewMargin)
                make.height.equalTo(40)
            }
            /*
        case .delete:
            deleteBtn.snp.makeConstraints { (make) in
                make.left.equalTo(rightBoxView).offset(kGoodsControlViewMargin)
                make.right.bottom.equalToSuperview().offset(-kGoodsControlViewMargin)
                make.height.equalTo(30)
            }
            break
            */
        default:
            plusOrReduceBtn.snp.makeConstraints { (make) in
                make.left.equalTo(rightBoxView).offset(kGoodsControlViewMargin)
                make.right.bottom.equalToSuperview().offset(-kGoodsControlViewMargin)
                make.height.equalTo(30)
            }
            deleteBtn.snp.makeConstraints { (make) in
                make.left.equalTo(rightBoxView).offset(kGoodsControlViewMargin)
                make.right.bottom.equalToSuperview().offset(-kGoodsControlViewMargin)
                make.height.equalTo(30)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension GoodsControlView:PPNumberButtonDelegate {
    func numberButtonResult(_ numberButton: PPNumberButton, number: String) {
        if let delegate = delegate {
            delegate.numberButtonResult(numberButton, number: number)
        }
    }
}



