//
//  AppDelegate.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

/*崩溃日志分析 -- KSCrash*/
import KSCrash

//极光推送
private let appKey = "ab41cd22bd8a22eab33f9b81"
private let channel = "App Store"
private let isProduction = false

//友盟分享
//private let USHARE_DEMO_APPKEY = "5977ea95a3251172f0000417"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate,BMKGeneralDelegate,JPUSHRegisterDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        /* 打开调试日志 */
//        UMSocialManager.default().openLog(true)
//        /* 设置友盟appkey */
//        UMSocialManager.default().umSocialAppkey = USHARE_DEMO_APPKEY
//        configUSharePlatforms()
//        confitUShareSettings()
        
        // MARK: -- 极光推送
        //Required
        //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
        let entity = JPUSHRegisterEntity()
        entity.types = Int(UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue)
        if (Float(UIDevice.current.systemVersion.components(separatedBy: ".")[0])! >= 8.0) {
            // 可以添加自定义categories
            // NSSet<UNNotificationCategory *> *categories for iOS10 or later
            // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        //如不需要使用IDFA，advertisingIdentifier 可为nil
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction)
        //2.1.9版本新增获取registration id block接口。
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if (resCode == 0){
                print("registrationID获取成功:\(resCode)")
            }else {
                print("registrationID获取失败:\(resCode)")
            }
        }
        
        // MARK: --  要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORDTYPE_BD09LL) {
            NSLog("经纬度类型设置成功");
        } else {
            NSLog("经纬度类型设置失败");
        }
        
        // MARK: -- 初始化百度地图
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("ALCh06zGYwPbFkTjsp5BnNRhDmisu2kP", generalDelegate: self)
        if ret == false {
            NSLog("百度地图初始化失败!")
        }
        
        
        //Mark: --- 崩溃日志报告加载
        
        let installation = KSCrashInstallationEmail.sharedInstance()
        installation?.recipients = ["26230197@qq.com"]
        
        installation?.addConditionalAlert(withTitle: "崩溃报告发送<感谢您的配合>", message: "应用程序上次意外退出, 发送报告?", yesAnswer: "确定", noAnswer: "不用了")
        installation?.setReportStyle(KSCrashEmailReportStyleApple, useDefaultFilenameFormat: true)
        
        installation?.install()
        
        installation?.sendAllReports(completion: { (result, completed, error) in
            
        })
        
        // MARK: -- 初始化window
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white;
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        if let guide: [String:String] = userDefault.value(forKey: "GuideHistory") as! [String:String]?, guide["tag"] == "1",guide["version"] == version{
            
            if UserStoreManager.sharedManager.getStoreName() == "NotSet" {
                let storeVC = ChooseStoreVC()
                storeVC.type = 2
                window?.rootViewController = storeVC
            }else {
                let rootVC = TabBarController.shareTabBarController
                window?.rootViewController = rootVC
            }
        
        }else {
            userDefault.setValue(["tag":"1","version":version], forKey: "GuideHistory")
            let vc = GuideVC()
            window?.rootViewController = vc
        }
        self.window?.makeKeyAndVisible();
        return true
    }
    

    
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // MARK: -- 通知
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Device Token:\(deviceToken)")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error:\(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        print("iOS7及以上系统，收到通知:\(self.logDic(dic: userInfo as! [String : String]) ?? "")")
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // MARK: -- JPUSHRegisterDelegate
    @available(iOS 10.0, *) func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {

        let userInfo = notification.request.content.userInfo

        let request = notification.request// 收到推送的请求
        let content = request.content// 收到推送的消息内容

        let badge = content.badge// 推送消息的角标
        let body = content.body// 推送消息体
        let sound = content.sound// 推送消息的声音
        let subtitle = content.subtitle// 推送消息的副标题
        let title = content.title// 推送消息的标题

        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotifitionData"), object: nil)
            JPUSHService.handleRemoteNotification(userInfo)
            print("iOS10 前台收到远程通知:\(self.logDic(dic: userInfo) ?? "")")
        }
        else {
            // 判断为本地通知
            print("iOS10 前台收到本地通知:{\nbody:\(body)，\ntitle:\(title),\nsubtitle:\(subtitle),\nbadge：\(String(describing: badge))，\nsound：\(String(describing: sound))，\nuserInfo：\(userInfo)\n}");
        }
        completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue|UNNotificationPresentationOptions.sound.rawValue|UNNotificationPresentationOptions.alert.rawValue)); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置

    }
    @available(iOS 10.0, *) func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {

        let userInfo = response.notification.request.content.userInfo

        let request = response.notification.request// 收到推送的请求
        let content = request.content// 收到推送的消息内容

        let badge = content.badge// 推送消息的角标
        let body = content.body// 推送消息体
        let sound = content.sound// 推送消息的声音
        let subtitle = content.subtitle// 推送消息的副标题
        let title = content.title// 推送消息的标题

        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotifitionData"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectNotifition"), object: nil)
            JPUSHService.handleRemoteNotification(userInfo)
            print("iOS10 收到远程通知:\(self.logDic(dic: userInfo) ?? "")")
        }
        else {
            // 判断为本地通知
            print("iOS10 收到本地通知:{\nbody:\(body)，\ntitle:\(title),\nsubtitle:\(subtitle),\nbadge：\(String(describing: badge))，\nsound：\(String(describing: sound))，\nuserInfo：\(userInfo)\n}");
        }
        completionHandler()  // 系统要求执行这个方法

    }
    // log NSSet with UTF8
    // if not ,log will be \Uxxx
    func logDic(dic: [AnyHashable : Any]) -> String? {
        guard dic.count != 0 else {
            return nil
        }
        
        let tempStr1 = dic.description.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        
        return try! PropertyListSerialization.propertyList(from: tempData!, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! String
    }
    
    // MARK: -- 支付宝/微信
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //友盟分享
//        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
//        if (!result) {
            // 其他如支付等SDK的回调
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDic) in
                
            }
            
            WXApi.handleOpen(url, delegate: self)
//        }
//        return result;
        return true
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDic) in
//            
//        }
//        
//        WXApi.handleOpen(url, delegate: self)
//        
//        return true
//    }
    // MARK: -- 微信代理
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.self) {
            let response: PayResp = resp as! PayResp
            switch response.errCode {
            case WXSuccess.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Payment_WX_State"), object: nil, userInfo: ["state":"1"])
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Payment_WX_State"), object: nil, userInfo: ["state":"0"])
            }
        }
    }
    
    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }
    
    // MARK: - 友盟分享送设置
//    func confitUShareSettings(){
//    /*
//     * 打开图片水印
//     */
////        UMSocialGlobal.shareInstance().isUsingWaterMark = true
//
//    /*
//     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
//     <key>NSAppTransportSecurity</key>
//     <dict>
//     <key>NSAllowsArbitraryLoads</key>
//     <true/>
//     </dict>
//     */
//        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
//
//    }
//
//    func configUSharePlatforms(){
//    /*
//     设置微信的appKey和appSecret
//     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
//     */
//        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wxdc1e388c3822c80b", appSecret: "3baf1193c85774b3fd9d18447d76cab0", redirectURL: nil)
//    /*
//     * 移除相应平台的分享，如微信收藏
//     */
//    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
//
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     100424468.no permission of union id
//     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
//     */
//        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "1106235609", appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
//    }

}

