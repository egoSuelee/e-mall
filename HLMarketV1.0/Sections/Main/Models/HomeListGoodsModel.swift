//
//  HomeListGoodsModel.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/2.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HomeListGoodsModel: BaseModel {

    var cParentNo = ""
    var type = ""
    var goodsData = [ShopCartStyleModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "goodsData" {
            
            let arr = value as! [[String:Any]]
            
            let modelArr: [ShopCartStyleModel] = ShopCartStyleModel.mj_objectArray(withKeyValuesArray: arr).copy() as! [ShopCartStyleModel]
            
            super.setValue(modelArr, forKey: key)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
