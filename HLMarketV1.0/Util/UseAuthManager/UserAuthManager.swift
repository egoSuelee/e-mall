//
//  UserAuthManager.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 10/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class UserAuthManager: NSObject {

    
    static let sharedManager = UserAuthManager()
    
    
//判断用户是否登录
    
    func isUserLogin() -> Bool {
        let usermodel = UserAuthManager.sharedManager.getUserModel()
        
        if usermodel == nil {
            return false
        } else {
            return true
        }
    }
    
//保存用户信息
    func saveUserInfo(userModel:UserAuthModel) {
        let modelData = NSKeyedArchiver.archivedData(withRootObject: userModel)
        userDefault.set(modelData, forKey: "hlUserModel")
    }
    

//获取用户信息
    
    func getUserModel() -> UserAuthModel? {
        let modelData = userDefault.data(forKey: "hlUserModel")
        if modelData == nil {
            return nil
        }
        if  (NSKeyedUnarchiver.unarchiveObject(with: modelData!) != nil)  {
            return NSKeyedUnarchiver.unarchiveObject(with: modelData!) as! UserAuthModel?
        }
        return nil
    }
    
    
//清除用户信息
    func cleanUserInfo() {
        userDefault.removeObject(forKey: "hlUserModel")
        userDefault.synchronize()
    }
    
}
