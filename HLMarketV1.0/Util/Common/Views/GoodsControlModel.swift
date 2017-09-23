//
//  GoodsControlModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 10/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class GoodsControlModel: NSObject {
    
    var avtarImage:String = ""
    var title:String = ""
    var price:String = ""
    var count:String = ""
    var realcount:String = ""
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
