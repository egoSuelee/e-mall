//
//  GoodsDetailModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/7/21.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class GoodsImageModel:BaseModel {
    var cShowLevel = ""
    var cGoodsImagePath = ""
}
class GoodsSpecPriceModel:BaseModel {
    var cPrice=""
    var cLower=""
    var cUpper=""
}
class GoodsSpecsModel:BaseModel {
    
    var cSpecAmount=""
    var cUnit=""
    var cGoodsNo=""
    var cSpec=""
    var cSpecDescrible = ""
    var cSpecPrices = [GoodsSpecPriceModel]()
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "cSpecPrices" {
            let arr = value as! [[String:Any]]
            if arr.count == 0 {
                super.setValue(arr, forKey: key)
            }else{
                let modelArr: [GoodsSpecPriceModel] = GoodsSpecPriceModel.mj_objectArray(withKeyValuesArray: arr).copy() as! [GoodsSpecPriceModel]
                super.setValue(modelArr, forKey: key)
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class GoodsDetailModel: BaseModel {
    
    var SelectNum="1"
    var SelectPrice=""
    
    var Description=""
    var cSpec=""
    var cFeatureTags=""
    var cGoodsName=""
    var cSupportDistribution=""
    var cGoodsNo=""
    var bOnLine_Price=""
    var cSupportMingRiSongDa=""
    var cGoodsImagePath=""
    var cMarketingTags=""
    var cUnit=""
    
    var cGoodsImages=[GoodsImageModel]()
    var cGoodsSpecs=[GoodsSpecsModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "cGoodsImages" {
            let arr = value as! [[String:Any]]
            if arr.count == 0 {
                super.setValue(arr, forKey: key)
            }else{
                let modelArr: [GoodsImageModel] = GoodsImageModel.mj_objectArray(withKeyValuesArray: arr).copy() as! [GoodsImageModel]
                super.setValue(modelArr, forKey: key)
            }
        } else if key == "cGoodsSpecs" {
            let arr = value as! [[String:Any]]
            if arr.count == 0 {
                super.setValue(arr, forKey: key)
            }else{
                let modelArr: [GoodsSpecsModel] = GoodsSpecsModel.mj_objectArray(withKeyValuesArray: arr).copy() as! [GoodsSpecsModel]
                super.setValue(modelArr, forKey: key)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
