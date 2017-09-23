//
//  UIBarButtonItem-Extension.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName:String,
                     highLightImage:String = "",
                     size : CGSize = CGSize.zero,
                     target:UIViewController,
                     action:Selector) {
        let btn = UIButton(type:.custom)
        btn.setImage(UIImage(named : imageName), for: .normal)
        if highLightImage != ""{
            btn.setImage(UIImage(named : highLightImage), for: .highlighted)
        }
        if size != CGSize.zero{
            btn.frame = CGRect (origin: CGPoint.zero, size: size)
        }else
        {
            btn.sizeToFit()
        }
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
    
    
    
    
    
    
    
    
    
    
}
