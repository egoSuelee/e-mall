//
//  BaseModel.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/10.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class BaseModel: NSObject {

    override init() {
        super.init()
    }
    
    init(dict: [String:NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    //setValuesForKeysWithDictionary 字典转模型
    
    //setValue:forUndefinedKey:这个方法是关键,只有存在这个方法后,才可以过滤掉不存在的键值对而防止崩溃,同时,setValue:forUndefinedKey:这个方法中还可以改变系统的敏感字,或者,你手动的映射key值不同的值,随你自己喜欢
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var debugDescription: String {
        
        var dic = [String:String]()
        var count = uint()
        let properties = class_copyPropertyList(self.classForKeyedArchiver, &count)!
        
        for i in 0..<count {
            let name = String.init(cString: property_getName(properties[Int(i)]), encoding: .utf8)
            let value = self.value(forKey: name!)
            dic["\(name!)"] = "\(value!)"
        }
        
        free(properties)
        
        return String.init(format: "%@ -- %@", self,dic)
        
    }
    
}
