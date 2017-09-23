//
//  OrderPayStyleTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/31.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class OrderPayStyleTCell: UITableViewCell {
    
    lazy var selectImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = #imageLiteral(resourceName: "hlm_disSelected")
        return imageView
    }()
    
    lazy var payStyleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()

    var dic: [String:String]? {
        didSet{
            self.payStyleLabel.text = "\(dic!["Describe"]!)"
        }
    }
    
    var selectedState: Bool? {
        didSet{
            self.selectImageView.image = selectedState! ? #imageLiteral(resourceName: "hlm_selected") : #imageLiteral(resourceName: "hlm_disSelected")
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(selectImageView)
        self.contentView.addSubview(payStyleLabel)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        payStyleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(50)
        }
        
        selectImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalTo(payStyleLabel.snp.right)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(selectImageView.snp.height)
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
