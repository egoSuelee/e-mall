//
//  ProfileTableCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/15.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class ProfileTableCell: UITableViewCell {
    
    lazy var sepLineLabel:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(sepLineLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
