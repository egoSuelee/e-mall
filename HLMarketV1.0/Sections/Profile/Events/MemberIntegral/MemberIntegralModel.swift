//
//  MemberIntegralModel.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/29.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class MemberIntegralModel: BaseModel {
    var RowNumber = ""
    var cVipNo = ""
    var dSaleDate = ""
    var date = MemberIntegralDateModel.init(str: nil)
    var fVipScore_cur = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if (key == "dSaleDate") {
            self.date = MemberIntegralDateModel.init(str: value as? String)
        }
        super.setValue(value, forKey: key)
    }
}

class MemberIntegralDateModel: BaseModel {
    var year = ""
    var month = ""
    var day = ""
    var hms = ""
    var time: String {
        get{
            return day + "日 " + hms
        }
    }
    init(str: String?) {
        super.init()
        
        guard let str = str else {
            return
        }
        
        let arr = str.components(separatedBy: " ")
        let str1 = arr[0]
        let str2 = arr[1]
        let arr1 = str1.components(separatedBy: "-")
        let arr2 = str2.components(separatedBy: ".")
        
        guard arr1.count >= 3, arr2.count >= 1 else {
            return
        }
        
        self.year = arr1[0]
        self.month = arr1[1]
        self.day = arr1[2]
        self.hms = arr2[0]
    }
    
    func isSameMonth(item:MemberIntegralDateModel?) -> Bool {
        guard let item = item else {
            return false
        }
        if self.year == item.year && self.month == item.month {
            return true
        }else{
            return false
        }
    }
    
    func getMonthTitle() -> String {
        
        let date = Date()
        let formate = DateFormatter()
        formate.dateFormat = "yyyy"
        let formate1 = DateFormatter()
        formate1.dateFormat = "mm"
        let currentYear = formate.string(from: date)
        let currentMonth = formate1.string(from: date)
        
        switch (self.year,self.month) {
        case (currentYear,currentMonth):
            return "本月"
        case (currentYear,_):
            return "\(self.month)月"
        default:
            return "\(self.year)年\(self.month)月"
        }
        
    }
}
