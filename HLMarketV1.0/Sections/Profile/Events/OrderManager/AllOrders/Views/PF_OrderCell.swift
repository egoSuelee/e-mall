//
//  PF_OrderCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/8/4.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//


import UIKit

let kHOrderGoodsCellHeight = (kScreenH-kStatusBarH-kNavigationBarH)/6 + _1pxWidth
fileprivate let baseTextSize = kHOrderGoodsCellHeight/10
fileprivate let scaleRate:CGFloat = 0.5

class PF_OrderCell: UITableViewCell {
    
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
    
    var rightContainerLeft = UIView.init()
    var rightContainerRight = UIView.init()
    
    var rightTopBox = UIView.init()
    var rightBotBox = UIView.init()
    
    var rightBotLeftWrapper = UIView.init()
    var rightBotRightWrapper = UIView.init()
    
    //Mark: --- 信息源
    
    lazy var goodsNameLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0x383838)
        label.font = UIFont.systemFont(ofSize: baseTextSize*3*scaleRate)
        return label
        }()
    lazy var goodsSpecLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0x7d7d7d)
        label.font = UIFont.systemFont(ofSize: baseTextSize*2.3*scaleRate)
        return label
        }()
    lazy var priceLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0x7d7d7d)
        label.font = UIFont.systemFont(ofSize: baseTextSize*2.3*scaleRate)
        return label
        }()
    lazy var countLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        //label.textColor = UIColor.colorFromHex(0xF02B2B)
        label.textColor = UIColor.colorFromHex(0x484848)
        label.font = UIFont.systemFont(ofSize: baseTextSize*2.6*scaleRate)
        return label
        }()
    
    lazy var totalMoneyLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0xF02B2B)
        label.font = UIFont.systemFont(ofSize: baseTextSize*3*scaleRate)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
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
        _ = [rightContainerLeft, rightContainerRight].map {
            rightContainer.addSubview($0)
        }
        _ = [rightTopBox, rightBotBox].map {
            rightContainerLeft.addSubview($0)
        }
        
        rightContainerRight.addSubview(totalMoneyLabel)
        
        rightTopBox.addSubview(goodsNameLabel)
        rightTopBox.addSubview(goodsSpecLabel)
        
        _ = [rightBotLeftWrapper, rightBotRightWrapper].map {
            rightBotBox.addSubview($0)
            
        }
        rightBotLeftWrapper.addSubview(priceLabel)
        rightBotLeftWrapper.addSubview(countLabel)
        
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
        
        rightContainerLeft.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        rightContainerRight.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        totalMoneyLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.height.equalToSuperview().multipliedBy(0.6)
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
        goodsSpecLabel.snp.makeConstraints { (make) in
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
            make.width.equalToSuperview().multipliedBy(1.6)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        countLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        rightBotRightWrapper.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
