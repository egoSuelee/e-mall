//
//  AlipayOrder.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/20.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class AlipayOrder: NSObject {

    var partner = ""
    var seller = ""
    var tradeNO = ""
    var productName = ""
    var productDescription = ""
    var amount = ""
    var notifyURL = ""
    
    var service = ""
    var paymentType = ""
    var inputCharset = ""
    var itBPay = ""
    var showUrl = ""
    
    var rsaDate = ""//可选
    var appID = ""//可选
    
    var extraParams = [String:String]()//额外信息
    
    // MARK: -- 生成商品明细
    func createGoodsDetail(goodsArr: [[String:String]]) -> String {
        var str = ""
        
        for dic in goodsArr {
            
            str += ",\(dic["cGoodsName"] ?? "")(数量:\(dic["Num"] ?? ""))"
            
        }
        str = str.substring(from: str.index(after: str.startIndex))
        
        return "{\"goods_detail\":[\(str)]}"
    }

    func orderStr() -> String {
        
        var dis = ""
        
        if (self.partner != "") {
            dis = dis + "partner=\"\(self.partner)\""
        }
        if (self.seller != "") {
            dis = dis + "&seller_id=\"\(self.seller)\""
        }
        if (self.tradeNO != "") {
            dis = dis + "&out_trade_no=\"\(self.tradeNO)\""
        }
        if (self.productName != "") {
            dis = dis + "&subject=\"\(self.productName)\""
        }
        if (self.productDescription != "") {
            dis = dis + "&body=\"\(self.productDescription)\""
        }
        if (self.amount != "") {
            dis = dis + "&total_fee=\"\(self.amount)\""
        }
        if (self.notifyURL != "") {
            dis = dis + "&notify_url=\"\(self.notifyURL)\""
        }
        if (self.service != "") {
            dis = dis + "&service=\"\(self.service)\""
        }
        if (self.paymentType != "") {
            dis = dis + "&payment_type=\"\(self.paymentType)\""
        }
        if (self.inputCharset != "") {
            dis = dis + "&_input_charset=\"\(self.inputCharset)\""
        }
        if (self.itBPay != "") {
            dis = dis + "&it_b_pay=\"\(self.itBPay)\""
        }
        if (self.showUrl != "") {
            dis = dis + "&show_url=\"\(self.showUrl)\""
        }
        if (self.rsaDate != "") {
            dis = dis + "&sign_date=\"\(self.rsaDate)\""
        }
        if (self.appID != "") {
            dis = dis + "&app_id=\"\(self.appID)\""
        }
        for (key,value) in self.extraParams {
            dis = dis + "&\(key)=\"\(value)\""
        }
        return dis;
    }
}
