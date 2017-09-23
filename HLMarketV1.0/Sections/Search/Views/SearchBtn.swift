//
//  SearchBtn.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/26.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class SearchBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = frame.height/2
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setImage(#imageLiteral(resourceName: "hlm_search_icon"), for: .normal)
        self.setImage(#imageLiteral(resourceName: "hlm_search_icon"), for: .highlighted)
        self.setTitle("请输入商品名称进行搜索", for: .normal)
        self.setTitleColor(UIColor.init(gray: 110), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.HL_x = 15
        imageView?.HL_centerY = HL_height * 0.5
        
        titleLabel?.sizeToFit()
        
        titleLabel?.HL_x = (imageView?.frame)!.maxX + 15
        titleLabel?.HL_centerY = HL_height * 0.5
        
    }

}
