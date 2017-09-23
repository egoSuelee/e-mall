//
//  HL_LeftTextRightImageBtn.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/3.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HL_LeftTextRightImageBtn: UIButton {

    var margin : CGFloat = 5
    var scale : CGFloat = 0.5
    /**
     图片在上面的Button
     */
    
    init(frame: CGRect, scale: CGFloat = 0.5, margin: CGFloat = 5) {
        super.init(frame: frame)
        self.scale = scale
        self.margin = margin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.HL_centerX = HL_width * scale * 0.7
        titleLabel?.HL_centerY = HL_height * 0.5
        
        titleLabel?.sizeToFit()
        
        imageView?.HL_centerY = HL_height * 0.5
        imageView?.HL_x = (titleLabel?.frame)!.maxX + margin
        
    }


}
