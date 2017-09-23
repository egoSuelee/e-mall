
//
//  UserAuthModel.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 10/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class UserAuthModel: NSObject, NSCoding {

    var UserNo :  String = ""
    var Email  :  String = ""
    var UserPass: String = ""
    var UserName: String = ""
    var UserIcon: String = ""
    var cStoreNo: String = ""
    
    override init() {
        super.init()
    }
    
    //编码成object
    func encode(with aCoder: NSCoder) {
        aCoder.encode(UserNo, forKey: "UserNo")
        aCoder.encode(Email, forKey: "Email")
        aCoder.encode(UserPass, forKey: "UserPass")
        aCoder.encode(UserName, forKey: "UserName")
        aCoder.encode(UserIcon, forKey: "UserIcon")
        aCoder.encode(cStoreNo, forKey: "cStoreNo")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        UserNo = aDecoder.decodeObject(forKey: "UserNo") as! String
        Email  = aDecoder.decodeObject(forKey: "Email") as! String
        UserPass = aDecoder.decodeObject(forKey: "UserPass") as! String
        UserName = aDecoder.decodeObject(forKey: "UserName") as! String
        UserIcon = aDecoder.decodeObject(forKey: "UserIcon") as! String
        cStoreNo = aDecoder.decodeObject(forKey: "cStoreNo") as! String
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    
}
