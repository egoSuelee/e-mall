//
//  OrderPayShopOrTimeTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class OrderPayShopOrTimeTCell: UITableViewCell {
    
    lazy var titleImageView: UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
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

    lazy var selectImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = #imageLiteral(resourceName: "hlm_address_arrow")
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
        }
    }
    
    var timeData: SendTime? {
        didSet{
            guard let timeData = self.timeData else {
                return
            }
            self.titleImageView.image = #imageLiteral(resourceName: "hlp_order_time")
            self.firstLabel.text = timeData.time;
            self.secondLabel.text = timeData.time1 + "~" + timeData.time2;
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleImageView)
        self.contentView.addSubview(firstLabel)
        self.contentView.addSubview(secondLabel)
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
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(titleImageView.snp.height)
        }
        
        firstLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleImageView.snp.right).offset(10)
            make.width.equalTo(secondLabel.snp.width)
        }
        
        secondLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(firstLabel.snp.right)
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
