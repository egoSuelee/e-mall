




//
//  ShopCartManager.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 11/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShopCartManager: NSObject {
    
    //MARK: --- 单例
    static let sharedShopCartManager = ShopCartManager()
    
    //选中的所有索引
    var selectedIndexs:[Int] = []
    // 数据源中所有索引
    var allIndexs:[Int] = []
    
    //存放所有数据源
    var models:[ShopCartServerModel] = []
    
    
    var totoalMoney:Float {
        get {
            var total:Float = 0
            if selectedIndexs.count == 0 {
                return total
            }
            
            for i in selectedIndexs {
                let price = (models[i].Last_Price as NSString).floatValue
                let num   = (models[i].Num as NSString).floatValue
                total += price * num
            }
            
            return total
        }
    }
    
    override init() {
        super.init()
        
        //请求数据,并且封装对象
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            AlamofireNetWork.required(urlString: "/Simple_online/Select_Shop_cart", method: .post, parameters: ["UserNo":userNo, "Number_of_pages":"1","cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (results) in
                
                let json = JSON(results)
                if json["resultStatus"] == "1" {
                    let dictArray = json["dDate"].arrayObject
                    for aDict in dictArray! {
                        let aDict:[String:Any] = aDict as! [String : Any]
                        let model = ShopCartServerModel.init(dict: aDict)
                        self.models.append(model)
                    }
                    //MARK: --- 给所有索引加入数据源
                    for i in 0..<self.models.count {
                        self.allIndexs.append(i)
                    }
                    
                    //这里得有一个回调, 告诉controller刷新数据
                    let notificationName = Notification.Name(rawValue: "ReloadDataNotification")
                    NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["value1":"hangge.com", "value2" : 12345])
                    
                }
            }) { (error) in
                
            }
        }
   
    }
    
    
    func add(index:Int) {
        //MARK: --- 如果数组为空, 直接添加 即可
        if selectedIndexs.count == 0 {
            selectedIndexs.append(index)
        }
        //MARK: --- 如果数据源已经有了该数据, 那么就不用添加
        for i in selectedIndexs {
            if i == index {
                return
            }
        }
        selectedIndexs.append(index)
    }

    func remove(index:Int) {
        //MARK: --- 如果数组为空, 直接添加 即可
        if selectedIndexs.count == 0 {
            return
        }
        
        selectedIndexs.remove(at: index)
    }
    

}













