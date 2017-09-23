

//
//  ShopCartGoodModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 11/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class ShopCartGoodModel: NSObject {

    var name:String = ""
    var price:String = "0"
    var count:String = "0"
    var isSelected:Bool = false
    var avtarImage:String = ""
    var goodId:String = ""
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
