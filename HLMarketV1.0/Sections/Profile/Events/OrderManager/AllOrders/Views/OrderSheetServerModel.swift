
//
//  OrderSheetServerModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 13/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class OrderSheetServerModel: NSObject {
    
    var detailsModels:[OrderGoodsServerModel] = []
    var Send_Money = ""
    var Total_money = ""
    var Date_time = ""
    var Pay_wayId = ""
    var All_Money = ""
    var Send_Way = ""
    var cTel = ""
    var Pay_state = ""
    var Reality_All_Money = ""
    var cStoreName = ""
    var Send_cStoreNo = ""
    var cSheetno = ""
    
    init(dict:[String:Any]) {
        super.init()
        for (key, value) in dict {
            if key == "details_list" {
                let newdictArr = value as! Array<Any>
                for aDict in newdictArr {
                    detailsModels.append(OrderGoodsServerModel.init(dict: aDict as! [String : Any]))
                }
            }else {
                setValuesForKeys([key : value])
            }
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
