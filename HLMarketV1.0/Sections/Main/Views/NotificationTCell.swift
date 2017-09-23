//
//  NotificationTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/6.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class NotificationTCell: UITableViewCell {
    
    @IBOutlet weak var backContentView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var strLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backContentView.layer.cornerRadius = 5
        self.backContentView.layer.masksToBounds = true
        self.tagLabel.layer.cornerRadius = 5
        self.tagLabel.layer.masksToBounds = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
