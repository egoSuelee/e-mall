//
//  HomeVCTableCell1.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/7/27.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HomeVCTableCell1: UITableViewCell {
    
    @IBOutlet weak var bcTopConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var imageViews: UIImageView!
    
    @IBOutlet weak var bc: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.bc.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
