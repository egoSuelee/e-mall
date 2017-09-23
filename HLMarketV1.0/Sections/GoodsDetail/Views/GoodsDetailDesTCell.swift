//
//  GoodsDetailDesTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/8/4.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class GoodsDetailDesTCell: UITableViewCell {
    
    var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 12)
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, WID/2, 0, WID/2))
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
