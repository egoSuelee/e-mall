//
//  AllExtension.swift
//  HLProcurementSwift
//
//  Created by 彭仁帅 on 2017/1/6.
//  Copyright © 2017年 PigPRS. All rights reserved.
//

import UIKit

// MARK: -- UIAlertController
extension UIAlertController {
    
    /// AlertContrller（不带Action）
    ///
    /// - Parameters:
    ///   - target: 视图控制器
    ///   - title: 标题
    ///   - message: 信息
    ///   - second: 几秒后消失
    class func show(target: AnyObject, title: String = "提示", message: String, second: Float = 2.5){
        
        let alertContrller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        target.present(alertContrller, animated: true, completion: nil)
        
        DispatchQueue_AfterExecute(delay:1, blok:{
            alertContrller.dismiss(animated: true, completion: nil)
        })
        
    }
    
    /// AlertContrller（带两个自定义的Action）
    ///
    /// - Parameters:
    ///   - target: 视图控制器
    ///   - type: 类型（默认：'alert'）
    ///   - alertAction1: 第一个自定义的Action
    ///   - alertAction2: 第二个自定义的Action
    ///   - title: 标题（默认：'提示'）
    ///   - message: 信息
    ///   - isHaveTextField: 是否有输入框（默认：false）
    class func showAction(target: AnyObject, type: UIAlertControllerStyle = .alert, alertAction1: UIAlertAction?, alertAction2: UIAlertAction?, title: String = "提示", message: String, isHaveTextField: Bool = false) -> UIAlertController{
        
        let alertContrller = UIAlertController.init(title: title, message: message, preferredStyle: type)
        
        if let action1 = alertAction1 {
            alertContrller.addAction(action1)
        }
        
        if let action2 = alertAction2 {
            alertContrller.addAction(action2)
        }
        
        if isHaveTextField == false {
            target.present(alertContrller, animated: true, completion: nil)
        }
        
        return alertContrller
        
    }
    
}

extension String {
    
    func md5String() -> String{
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    func cgFloatString()->String{
        let string = self
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string){
            cgFloat = CGFloat(doubleValue)
        }
        return String.init(format: "%0.2f", cgFloat)
    }
    
    func intString()->String{
        let string = self
        var int:Int = 0
        if let doubleValue = Double(string) {
            int = Int(doubleValue)
        }
        return "\(int)"
    }
    
}

extension UIView{
    
    
    var  HL_x : CGFloat {
        get{
            return self.frame.origin.x
        }
        
        set{
            var frame : CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    
    var  HL_y : CGFloat {
        get{
            return self.frame.origin.y
        }
        
        set{
            var frame : CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    
    var  HL_width : CGFloat {
        get{
            return self.frame.width
        }
        
        set{
            var frame :CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var  HL_height : CGFloat {
        get{
            return self.frame.height
        }
        
        set{
            var frame :CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    
    
    var HL_centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            var center :CGPoint = self.center
            center.x = newValue
            self.center = center
            
        }
    }
    
    
    
    var HL_centerY : CGFloat{
        get{
            return self.center.y
        }
        
        set{
            var center :CGPoint = self.center
            center.y = newValue
            self.center = center
            
        }
    }
    
}




