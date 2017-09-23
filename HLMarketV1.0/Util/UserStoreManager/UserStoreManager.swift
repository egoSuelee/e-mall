//
//  UserStoreManager.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 26/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class UserStoreManager: NSObject {
    
    static let sharedManager = UserStoreManager()
    
    
    var storeNo:String {
        get {
            return getStoreNo()
        }
    }
    
    var storeName:String {
        get {
            return getStoreName()
        }
    }
    
    func getStoreNo() -> String {
        if let storeNo = userDefault.object(forKey: UserDefaultStoreNo) {
            return storeNo as! String
        } else {
            return "NotSet"
        }
    }
    
    func getStoreName() -> String {
        if let storeName = userDefault.object(forKey: UserDefaultStoreName)
        {
            return storeName as! String
        } else {
            return "NotSet"
        }
    }
    
    func save(storeNo:String) {
        userDefault.set(storeNo, forKey: UserDefaultStoreNo)
    }
    
    func saveStoreName(storeName:String) {
        userDefault.set(storeName, forKey: UserDefaultStoreName)
    }
    
}
