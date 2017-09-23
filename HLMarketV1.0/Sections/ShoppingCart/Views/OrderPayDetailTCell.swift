//
//  OrderPayDetailTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class OrderPayDetailTCell: UITableViewCell {
    
    lazy var titleLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "商品总额:"
        label.textAlignment = .right
        return label
    }()
    
    lazy var titleLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "配送费:"
        label.textAlignment = .right
        return label
    }()
    
    lazy var titleLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "优惠金额:"
        label.textAlignment = .right
        return label
    }()
    
    lazy var priceLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    lazy var priceLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    lazy var priceLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    var dataDic: [String:String]? {
        didSet{
            guard let dataDic = self.dataDic else {
                return
            }
            self.priceLabel1.text = dataDic["total"]
            self.priceLabel2.text = dataDic["freight"]
            self.priceLabel3.text = dataDic["discount"]
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel1)
        self.contentView.addSubview(priceLabel1)
        self.contentView.addSubview(titleLabel2)
        self.contentView.addSubview(priceLabel2)
        self.contentView.addSubview(titleLabel3)
        self.contentView.addSubview(priceLabel3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        titleLabel1.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        priceLabel1.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-WID*2)
            make.left.equalTo(titleLabel1.snp.right)
        }
        
        titleLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(titleLabel1.snp.height)
        }
        
        priceLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel1.snp.bottom)
            make.right.equalToSuperview().offset(-WID*2)
            make.left.equalTo(titleLabel2.snp.right)
            make.height.equalTo(priceLabel1.snp.height)
        }
        
        titleLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel2.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(titleLabel2.snp.height)
        }
        
        priceLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel2.snp.bottom)
            make.right.equalToSuperview().offset(-WID*2)
            make.left.equalTo(titleLabel3.snp.right)
            make.height.equalTo(priceLabel2.snp.height)
            make.bottom.equalToSuperview()
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
