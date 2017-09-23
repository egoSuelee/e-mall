//
//  HomeOftenGoodsTagView.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/28.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HomeOftenGoodsTagView: UIView {
    
    var bezierColor: UIColor = UIColor.clear
    
    func setIndex(_ index: Int) -> Void {
        var color = UIColor(red:0.973, green:0.776, blue:0.514, alpha:1.000)
        switch index {
        case 0:
            color = UIColor(red:0.980, green:0.275, blue:0.227, alpha:1.000)
        case 1:
            color = UIColor(red:0.965, green:0.478, blue:0.180, alpha:1.000)
        case 2:
            color = UIColor(red:1.000, green:0.600, blue:0.424, alpha:1.000)
        default:
            break
        }
        self.bezierColor = color
        self.setNeedsDisplay()
        self.addSubview(label)
        label.text = "\(index+1)"
    }
    
    lazy var label: UILabel! = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Zapfino", size: 15)
        label.textAlignment = .center
        return label
    }()

    override func draw(_ rect: CGRect) {
        self.bezierColor.set() // 设置线条颜色
        let aPath = UIBezierPath()
        aPath.lineWidth = 1.0 // 线条宽度
        aPath.lineCapStyle = CGLineCap.square // 线条拐角
        aPath.lineJoinStyle = CGLineJoin.miter // 终点处理
        
        // Set the starting point of the shape.
        aPath.move(to: CGPoint.init(x: 0, y: 0))
        
        // Draw the lines
        aPath.addLine(to: CGPoint.init(x: 44, y: 0))
        aPath.addLine(to: CGPoint.init(x: 0, y: 44))
        aPath.close() // 最后一条线通过调用closePath方法得到
        
        aPath.stroke() // Draws line 根据坐标点连线，不填充
        aPath.fill() // Draws line 根据坐标点连线，填充
    }

}
