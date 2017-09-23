//
//  HomeSectionHeaderView.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/5/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

class HomeSectionHeaderView: UIView {
    
    fileprivate lazy var bcLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    fileprivate lazy var bcImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init(frame: CGRect, title:String, titleImageName:String, titleColor: UIColor) {
        super.init(frame: frame)
        
        let mString = NSMutableAttributedString.init(string: title, attributes: [NSKernAttributeName:WID/3])
        let mStyle = NSMutableParagraphStyle()
        mStyle.alignment = .center
        mString.addAttribute(NSParagraphStyleAttributeName, value: mStyle, range: NSMakeRange(0, (title.characters.count)))
        bcLabel.attributedText = mString
        bcLabel.sizeToFit()
        bcLabel.textColor = titleColor
        bcImageView.image = UIImage.init(named: titleImageName)
        
        self.addSubview(bcImageView)
        self.addSubview(bcLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bcImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bcLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
