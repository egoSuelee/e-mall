
//
//  ChooseAddressCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 13/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class ChooseAddressCell: UITableViewCell {

    var isAvailable:Bool? {
        didSet {
            guard let isAvailable = isAvailable else {
                return
            }
            
            if !isAvailable {
                _ = [usernameLabel, userPhoneLabel, userAddressLabel].map {
                    $0.textColor = UIColor.colorFromHex(0xcdcdcd)
                }
                self.chooseIcon.image = UIImage.init(named: "hlm_notAvailableAddress_icon")
                
            } else {
                _ = [usernameLabel, userPhoneLabel, userAddressLabel].map {
                    $0.textColor = UIColor.black
                }
                self.chooseIcon.image = UIImage.init(named: "hlm_disSelected")
            }
        }
    }
    
    
    var isNotAvailableView = {
        () ->UIImageView in
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "hlm_notAvailableAddress_icon")
        return imageView
    }()
    
    var model:AddressUserModel? {
        didSet {
            usernameLabel.text = model?.UserName
            userPhoneLabel.text = model?.Tel
            userAddressLabel.text = model?.UserTotalAdressInfo
        }
    }
    
    
    lazy var midViewbox = {UIView.init()}()
    lazy var usernameLabel = {() -> UILabel in
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var userPhoneLabel = { () -> UILabel in
        let label = UILabel.init()
        label.textAlignment = .right
        
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    lazy var userAddressLabel = { () -> UILabel in
        let label = UILabel.init()
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var chooseIcon = {() ->UIImageView in
        let view = UIImageView.init(image: UIImage.init(named: "hlm_disSelected"))
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(midViewbox)
        self.contentView.addSubview(chooseIcon)
        
        self.midViewbox.addSubview(usernameLabel)
        self.midViewbox.addSubview(userPhoneLabel)
        self.midViewbox.addSubview(userAddressLabel)
        self.midViewbox.addSubview(isNotAvailableView)
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.size.height -= 1
            super.frame = newFrame
        }
    }
    func beColorful() {
        for view in midViewbox.subviews {
            view.backgroundColor = UIColor.randomColor()
        }
    }
    override func layoutSubviews() {
        
        chooseIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
 
        midViewbox.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-50)
            
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalToSuperview().dividedBy(2)
            make.left.top.equalToSuperview()
        }
        userPhoneLabel.snp.makeConstraints { (make) in
            make.height.width.equalTo(usernameLabel)
            make.right.top.equalToSuperview()
        }
        userAddressLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
