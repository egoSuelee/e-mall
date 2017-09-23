//
//  StoreModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 24/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class StoreModel: NSObject {

    
    var cStoreName:String = ""
    var cStoreNo:String = ""
    var cStyle:String = ""
    var cTel:String = ""
    var image_path:String = ""
    
    
    //店铺地址添加的字段
    var cOperator:String = ""
    var fLant:String = ""
    var id:String = ""
    var Tel:String = ""
    var fLont:String = ""
    var Address:String = ""
    var cOperatorNo:String = ""
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

class StoreAddressInfoModel: NSObject {
    var id:String = ""
    var Available:String = ""
    var fLant:String = ""
    var province:String = ""
    var beizhu2:String = ""
    var street:String = ""
    var fLont:String = ""
    var cOperatorNo:String = ""
    var Tel:String = ""
    var Address:String = ""
    var city:String = ""
    var cOperator:String = ""
    var cStoreName:String = ""
    var beizhu1:String = ""
    var cStoreNo:String = ""
    var district:String = ""
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}



