//
//  MemberIntegralTopView.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/28.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class MemberIntegralTopView: UIView {
    
    var integral: String?{
        didSet{
            guard let integral = integral else {
                return
            }
            label.frame = self.frame
            label.text = integral
            self.addSubview(label)
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()

    override func draw(_ rect: CGRect) {
        let color = UIColor.appMainColor()
        color.set() // 设置线条颜色
        
        // 根据传入的矩形画出内切圆／椭圆
        let aPath = UIBezierPath(ovalIn: CGRect(x: -kScreenW*0.75, y: (kScreenH-64)/3.5-kScreenW*2.5, width: kScreenW*2.5, height: kScreenW*2.5)) // 如果传入的是长方形，画出的就是内切椭圆
        aPath.fill() // Draws line 根据坐标点连线，填充
    }

}
