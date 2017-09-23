//
//  Constant.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

//mark: 用户登录/退出登录
enum HLUserAction {
    case logIn
    case logOut
}
//通知名称
let  userLoginOutActionNoficition = "kUserLoginOutActionNoficition"
let  goodsAddedToShopCart = "kGoodsAddedToShopCart"
let  goodsCollectCountChanged = "kGoodsCollectCountChanged"
let  addressInfoChanged = "kAddressInfoChanged"
let  NotiNameOfAfterChooseStore = NSNotification.Name("kAfterChooseStoreNotification")
let NotiNameOfCommitOrder = NSNotification.Name("kNotiNameOfCommitOrder")


//****************************//
//********  正则表达式   *******//
//****************************//

let PHONE_REG_PATTERN = "^((13[0-9])|(17[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\\d{8}$"





/// 归档路径
let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString

//使用userDefault进行轻量级的本地数据的读取/删除操作
let userDefault             = UserDefaults.standard
let UserDefaultStoreNo      = "kUserDefaultStoreNo"
let UserDefaultStoreName    = "kUserDefaultStoreName"
let USERDEFAULT_REDIRECTIP = "USERDEFAULT_REDIRECTIP"
let NotifyUpdateCategory = NSNotification.Name(rawValue:"notifyUpdateCategory")
let KSelectedChannel: String = "selectedChannel"

/// 常用属性
let PAGE_TITLES: String = "pagetitles.archive"
let HOME_CHILDVCS: String = "childvcs"
let DEFAULT_CHILDVCS: String = "default"



let DefaultURL     = "http://47.92.108.157:1237"
//let DefaultURL     = "http://119.29.67.22:1237"
//let DefaultURL     = "http://192.168.15.77:8080"

let ImageHAdUrl    = DefaultURL+"/Simple_onlineManger/images/Advertisement/"
let ImageTypeUrl   = DefaultURL+"/Simple_onlineManger/images/GroupType/"
let ImageGoodsUrl  = DefaultURL+"/Simple_onlineManger/images/Goods/"
let ImageStoreUrl  = DefaultURL+"/Simple_onlineManger/images/cStore/"

let kItemMargin : CGFloat = 10
let kHeaderViewH : CGFloat = 50
let kNormalItemW = (kScreenW - 5 * kItemMargin) / 4
let kNormalItemH = kNormalItemW * 3 / 4
let NormalCellID = "NormalCellID"
let SearchCellID = "SearchCellID"
let HeaderViewID = "HeaderViewID"

let kStatusBarH: CGFloat = 20
let kNavigationBarH: CGFloat = 44
let kTabBarH: CGFloat = 49
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
//屏幕宽度单元尺度
let WID = kScreenW/20
//屏幕高度单元尺度
let HEI = kScreenH/20
let BGCOLOR: UIColor = UIColor(gray: 244)
let _1pxWidth = 1 / UIScreen.main.scale
/// 获取当前时间
///
/// - Returns: 返回当前时间 年/月/日 的字符串
func getDate() -> String {
    let date = Date()
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

/// 字体函数
///
/// - Parameter a: 字体大小
/// - Returns: 字体型号
func font(_ a:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: a)
}

/// 延迟执行
///
/// - Parameters:
///   - delay: 延迟时间
///   - blok: 延迟执行的闭包
func DispatchQueue_AfterExecute(delay:Double, blok:@escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: blok)
    
}

/**
 plist文件路径
 
 - parameter filename: plist名字
 
 - returns: 返回plist文件所在的路径
 */
func SavePlistfilename(filename:String) -> String {
    return (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filename)
}

/// 获取当前屏幕的视图控制器
///
/// - Returns: 返回viewController
func getCurrentVC()->UIViewController{
    
    var window = UIApplication.shared.keyWindow
    if window?.windowLevel != UIWindowLevelNormal{
        let windows = UIApplication.shared.windows
        for  tempwin in windows{
            if tempwin.windowLevel == UIWindowLevelNormal{
                window = tempwin
                break
            }
        }
    }
    let frontView = (window?.subviews)![0]
    let nextResponder = frontView.next
    if nextResponder?.isKind(of: UIViewController.self) == true{
        return nextResponder as! UIViewController
    }else if nextResponder?.isKind(of: UINavigationController.self) == true{
        return (nextResponder as! UINavigationController).visibleViewController!
    }else {
        
        if (window?.rootViewController) is UINavigationController{
            return ((window?.rootViewController) as! UINavigationController).visibleViewController!//只有这个是显示的controller 是可以的必须有nav才行
        }
        //        else if (window?.rootViewController) is BoosjTabBarViewController{
        //            return ((window?.rootViewController) as! UITabBarController).selectedViewController! //不行只是最三个开始的页面
        //        }
        
        return (window?.rootViewController)!
        
    }
    
}
//保存到plist文件中
func savePlist(data:AnyObject,filename:String) {
    DispatchQueue.global().async {
        _ = data.write(toFile: SavePlistfilename(filename: filename), atomically: true)
    }
}
//获取plist文件
func getPlist(filename:String) -> (state: Bool, plist: AnyObject) {
    let plist = NSDictionary(contentsOfFile:SavePlistfilename(filename: filename))
    
    if plist != nil {
        return (true,plist!)
    }
    
    return (false,"没数据" as AnyObject)
}








