//
//  OrderPayShopTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/26.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class OrderPayShopTCell: UITableViewCell {
    
    lazy var titleImageView: UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var thirdLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var selectImageView: UIImageView = {
        let imageView = UIImageView.init()
//        imageView.image = #imageLiteral(resourceName: "hlm_address_arrow")
        return imageView
    }()
    
    var storeModel: StoreModel? {
        didSet{
            guard let storeModel = self.storeModel else {
                return
            }
            self.titleImageView.image = #imageLiteral(resourceName: "hlp_order_shop")
            self.firstLabel.text = storeModel.cStoreName
            self.secondLabel.text = storeModel.Tel
            self.thirdLabel.text = storeModel.Address
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleImageView)
        self.contentView.addSubview(firstLabel)
        self.contentView.addSubview(secondLabel)
        self.contentView.addSubview(thirdLabel)
        self.contentView.addSubview(selectImageView)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        titleImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(titleImageView.snp.height)
            make.height.equalToSuperview().dividedBy(2).offset(-10)
        }
        
        firstLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(titleImageView.snp.right).offset(10)
            make.width.equalTo(secondLabel.snp.width)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        secondLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(firstLabel.snp.right)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        thirdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(firstLabel)
            make.right.equalTo(secondLabel)
        }
        
        selectImageView.snp.makeConstraints { (make) in
            make.left.equalTo(secondLabel.snp.right)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(selectImageView.snp.width).multipliedBy(1.2)
            make.centerY.equalToSuperview()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
