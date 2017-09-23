//
//  ShopCartServerModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 13/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class ShopCartServerModel: NSObject {
    var Date_time:String = ""
    var Last_Price:String = ""
    var Num = ""
    var RowNumber = "10"
    var cGoodsImagePath = ""
    var cGoodsName = ""
    var cGoodsNo = ""
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    func beDict() -> Dictionary<String, String> {
        var aDict:Dictionary<String, Any> = Dictionary()
        aDict["cGoodsName"] = cGoodsName
        aDict["cGoodsNo"] = cGoodsNo
        aDict["Num"] = Num
        aDict["Last_Price"] = Last_Price
        aDict["cGoodsImagePath"] = cGoodsImagePath
        
        let price = (Last_Price as NSString).floatValue
        let num   = (Num as NSString).floatValue
        let total = price * num
        
        aDict["Last_Money"] = "\(total)"
        
        return aDict as! Dictionary<String, String>
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    
}
