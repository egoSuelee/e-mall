//
//  ChooseStoreAddressCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/4/28.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

class ChooseStoreAddressCell: UITableViewCell {

    var leftBoxView = UIView.init()
    var rightBoxView = UIView.init()
    
    var storeIconView = UIImageView.init()
    var storeNameLabel = UILabel.init()
    var addressLabel = UILabel.init()
    var phoneLabel = UILabel.init()
    var sepView:UIView?
    
    var model:StoreAddressInfoModel? {
        didSet {
            guard model != nil else {
                return
            }
            configureData()
        }
    }
    
    var bmkModel:BMKPoiInfo? {
        didSet {
            guard bmkModel != nil else {
                return
            }
            configureBMKData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setupUI()
    }
    
    func configureData() {
        storeNameLabel.text = model?.cStoreName
        addressLabel.text   = model?.Address
        phoneLabel.text     = model?.Tel
    }
    
    func configureBMKData() {
        storeNameLabel.text = bmkModel?.name
        addressLabel.text   = bmkModel?.address
    }
    
    func setupUI() {
        _ = leftBoxView.then {
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(leftBoxView.snp.height)
            })
        }
        
        _ = storeIconView.then {
            leftBoxView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.height.width.equalTo(30)
            })
            $0.image = UIImage.init(named: "hlm_store_address_icon")
        }
        _ = rightBoxView.then {
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.right.top.bottom.equalToSuperview()
                make.left.equalTo(leftBoxView.snp.right)
            })
        }
        
        _ = storeNameLabel.then {
            rightBoxView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.height.equalToSuperview().multipliedBy(0.618)
                make.top.left.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.6)
            })
            $0.font = UIFont.systemFont(ofSize: 18)
        }
        
        _ = phoneLabel.then {
            rightBoxView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(storeNameLabel)
                make.right.equalToSuperview().offset(-8)
                make.left.equalTo(storeNameLabel.snp.right)
            })
            $0.textAlignment = .right
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        
        _ = addressLabel.then {
            rightBoxView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalToSuperview()
                make.top.equalTo(storeNameLabel.snp.bottom)
            })
            $0.textColor = UIColor.colorFromHex(0xcdcdcd)
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        sepView = UIView.init().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.bottom.right.left.equalToSuperview()
                make.height.equalTo(0.5)
            })
            $0.backgroundColor = UIColor.colorFromHex(0xcdcdcd)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
