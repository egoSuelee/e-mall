//
//  URLManager.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/6/21.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class URLManager: NSObject {
    static let sharedURLManager = URLManager()
    
    var redirectURL:String? {
        get {
            let tmpURL = userDefault.object(forKey: USERDEFAULT_REDIRECTIP)
            
            if tmpURL != nil {
                return tmpURL as? String
            } else {
                return nil
            }
        }
    }
    
    var ImageHAdUrl:String? {
        get {
            if let redirectURL = redirectURL {
                return redirectURL + "/Simple_onlineManger/images/Advertisement/"
            } else {
                return nil
            }
        }
    }
    
    var ImageTypeUrl:String? {
        get {
            if let redirectURL = redirectURL {
                return redirectURL + "/Simple_onlineManger/images/GroupType/"
            } else {
                return nil
            }
        }
    }
    
    var ImageGoodsUrl:String? {
        get {
            if let redirectURL = redirectURL {
                return redirectURL + "/Simple_onlineManger/images/Goods/"
            } else {
                return nil
            }
        }
    }
    
    var ImageStoreUrl:String? {
        get {
            if let redirectURL = redirectURL {
                return redirectURL + "/Simple_onlineManger/images/cStore/"
            } else {
                return nil
            }
        }
    }
    
    
}
