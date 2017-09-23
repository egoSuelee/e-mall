//
//  UIImage-Extension.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//
import Foundation
import UIKit

extension UIImage {
    
    func resizeImage(_ toSize:CGSize,  scale:CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(toSize, false, scale)
        let imageRect = CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height)
        self.draw(in: imageRect, blendMode: CGBlendMode.clear, alpha: 1)
        let desImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return desImage!
    }
    
    
}


