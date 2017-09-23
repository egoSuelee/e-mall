//
//  UIColor-Extension.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

extension UIColor {
    /// rgb颜色
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0 ,green: g/255.0 ,blue: b/255.0 ,alpha:1.0)
    }
    /// 纯色（用于灰色）
    convenience init(gray: CGFloat) {
        self.init(red: gray/255.0 ,green: gray/255.0 ,blue: gray/255.0 ,alpha:1.0)
    }
    // 随机色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    class func appMainColor() -> UIColor {
        return UIColor.colorFromHex(0xff3951)
    }
    
    class func appTextMainColor() -> UIColor {
        return UIColor.colorFromHex(0xff3951)
    }
    
    class func deeperAppColor()-> UIColor {
        return UIColor.colorFromHex(0x6AB005)
    }
    
    class func appNavBarTitleColor() -> UIColor {
        return UIColor.colorFromHex(0x070B00)
    }
    
    class func sharedImageColor() ->UIColor {
        return UIColor.init(gray: 242)
    }
    
    class func deepColorWith(_ Hex:UInt32) -> UIColor {
        let red     = CGFloat((Hex & 0xFF0000) >> 16) * 0.92
        let green   = CGFloat((Hex & 0xFF00) >> 8) * 0.92
        let blue    = CGFloat((Hex & 0xFF)) * 0.92
        return UIColor.init(red: red/255.0,green: green/255.0,blue: blue/255.0,alpha: 1.0)
    }
    
    // 十六进制转换
    static func colorFromHex(_ Hex: UInt32) -> UIColor {
        return UIColor.init(red: CGFloat((Hex & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((Hex & 0xFF00) >> 8) / 255.0,
                            blue: CGFloat((Hex & 0xFF)) / 255.0,
                            alpha: 1.0)
    }
}
