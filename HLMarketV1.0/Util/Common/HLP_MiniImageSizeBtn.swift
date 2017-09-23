//
//  HLP_MiniImageSizeBtn.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/13.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

enum MiniImageSizeType {
    case square//长=宽
    case rectangle//长!=宽
    case widthLeft//长!=宽,左缩进(一排2个按钮的缩进方式)
    case widthRight//长!=宽,右缩进(一排2个按钮的缩进方式)
}

class HLP_MiniImageSizeBtn: UIButton {
    
    var scaleW: CGFloat = 0.5
    var scaleH: CGFloat = 0.5
    var type: MiniImageSizeType = .square

    class func image(scale:CGFloat, type: MiniImageSizeType = .square) -> HLP_MiniImageSizeBtn {
        let btn = HLP_MiniImageSizeBtn()
        btn.scaleW = scale
        btn.scaleH = scale
        btn.type = type
        return btn
    }
    
    class func image(scaleW:CGFloat, scaleH:CGFloat, type: MiniImageSizeType = .rectangle) -> HLP_MiniImageSizeBtn {
        let btn = HLP_MiniImageSizeBtn()
        btn.scaleW = scaleW
        btn.scaleH = scaleH
        btn.type = type
        return btn
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        switch self.type {
        case .square:
            let min = self.frame.size.width > self.frame.size.height ? self.frame.size.height :self.frame.size.width
            self.imageView?.frame = CGRect(x: 0, y: 0, width: min*scaleW, height: min*scaleH)
            self.imageView?.center = CGPoint(x: self.frame.size.width*0.5, y: self.frame.size.height*0.5)
        case .rectangle:
            self.imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width*scaleW, height: self.frame.size.height*scaleH)
            self.imageView?.center = CGPoint(x: self.frame.size.width*0.5, y: self.frame.size.height*0.5)
        case .widthLeft:
            self.imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width*scaleW, height: self.frame.size.height*scaleH)
            self.imageView?.center = CGPoint(x: self.frame.size.width * (0.5-(1-scaleW)/6), y: self.frame.size.height*0.5)
        case .widthRight:
            self.imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width*scaleW, height: self.frame.size.height*scaleH)
            self.imageView?.center = CGPoint(x: self.frame.size.width * (0.5+(1-scaleW)/6), y: self.frame.size.height*0.5)
        }
    }
}
