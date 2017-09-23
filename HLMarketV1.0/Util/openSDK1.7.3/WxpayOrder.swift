//
//  WxpayOrder.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/20.
//  Copyright © 2017年 egosuelee. All rights reserved.
//

import UIKit

class WxpayOrder: NSObject {

    var appid = ""
    var attach = ""
    var body = ""
    var detail = ""
    var mch_id = ""
    var notify_url = ""
    var out_trade_no = ""
    var total_fee = ""
    var key = ""
    fileprivate var device_info = "WEB"
    fileprivate var limit_pay = "no_credit"
    fileprivate var trade_type = "APP"
    fileprivate var nonce_str: String {
        get {
            return createWX_nonce_str()
        }
    }
    fileprivate var spbill_create_ip: String {
        get{
            return IPHelper.getIPAddress(true)
        }
    }
    fileprivate var time_expire: String {
        get{
            return getWXDate(timeInterval: 60*5)
        }
    }
    fileprivate var time_start: String {
        get{
            return getWXDate(timeInterval: 0)
        }
    }
    // MARK: -- 生成商品明细
    func createGoodsDetail(goodsArr: [[String:String]]) -> String {
        var str = ""
        
        for dic in goodsArr {
            
            str += ",{\"goods_id\":\"\(dic["cGoodsNo"] ?? "")\",\"goods_name\":\"\(dic["cGoodsName"] ?? "")\",\"quantity\":\(dic["Num"] ?? ""),\"price\":\(dic["Last_Price"] ?? "")}"
            
        }
        str = str.substring(from: str.index(after: str.startIndex))
        
        return "{\"goods_detail\":[\(str)]}"
    }
    // MARK: -- 生成“统一下单”数据
    func unifiedOrder() -> [String:String] {
        var disDic  = ["appid":self.appid,"attach":self.attach,"body":self.body,"detail":self.detail,"device_info":self.device_info,"limit_pay":self.limit_pay,"mch_id":self.mch_id,"nonce_str":self.nonce_str,"notify_url":self.notify_url,"out_trade_no":self.out_trade_no,"spbill_create_ip":self.spbill_create_ip,"time_expire":self.time_expire,"time_start":self.time_start,"total_fee":self.total_fee,"trade_type":self.trade_type]
        let sign = createWX_UnifiedOrder_Sign(dic: disDic)
        disDic["sign"] = sign
        return disDic
    }
    // MARK: -- 生成“统一下单”签名
    fileprivate func createWX_UnifiedOrder_Sign(dic: [String:String]) -> String {
        let signStr = "appid=\(dic["appid"]!)&attach=\(dic["attach"]!)&body=\(dic["body"]!)&detail=\(dic["detail"]!)&device_info=\(dic["device_info"]!)&limit_pay=\(dic["limit_pay"]!)&mch_id=\(dic["mch_id"]!)&nonce_str=\(dic["nonce_str"]!)&notify_url=\(dic["notify_url"]!)&out_trade_no=\(dic["out_trade_no"]!)&spbill_create_ip=\(dic["spbill_create_ip"]!)&time_expire=\(dic["time_expire"]!)&time_start=\(dic["time_start"]!)&total_fee=\(dic["total_fee"]!)&trade_type=\(dic["trade_type"]!)&key=\(self.key)"
        return signStr.md5String().uppercased()
    }
    // MARK: -- 生成“发起支付”签名
    func createWX_PayReq_Sign(request: PayReq) -> String {
        let signStr = "appid=\(self.appid)&noncestr=\(request.nonceStr!)&package=\(request.package!)&partnerid=\(request.partnerId!)&prepayid=\(request.prepayId!)&timestamp=\(request.timeStamp)&key=\(self.key)"
        return signStr.md5String()
    }
    // MARK: -- 生成随机字符串
    func createWX_nonce_str() -> String {
        let string = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var str = ""
        for _ in 0..<32 {
            let start: Int = Int(arc4random_uniform(32))
            let index = string.index(string.startIndex, offsetBy: start)
            let index1 = string.index(after: index)
            let c = string.substring(with: index..<index1)
            str.append(c)
        }
        return str
    }
    // MARK: -- 生成日期
    fileprivate func getWXDate(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceNow: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMddHHmmss"
        return dateformatter.string(from: date)
    }
    // MARK: -- 生成时间戳
    func getWX_PayReq_Date() -> Int {
        let senddate = Date()
        let timeSp = Int(senddate.timeIntervalSince1970)
        return timeSp
    }
    
}
