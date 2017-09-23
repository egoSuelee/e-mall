//
//  HomeVCADTableCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/8/2.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HomeVCADTableCell: UITableViewCell {
    
    fileprivate var bcImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "hlm_home_ads")
        return imageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.addSubview(bcImageView)
        
        bcImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
