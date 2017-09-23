
//
//  OrderGoodsServerModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 13/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class OrderGoodsServerModel: NSObject {

    var cGoodsNo = ""
    var cGoodsImagePath = ""
    var Description = ""
    var cSpec = ""
    var Last_Money = ""
    var RealityNum = ""
    var Num = ""
    var Reality_Money = ""
    var cGoodsName = ""
    var cUnit = ""
    var Last_Price = ""
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
