//
//  WalletHomeVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class WalletHomeVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "钱包"
        
        createUI()
    }
    
    func createUI() -> Void {
        
        let btnImageArr = [#imageLiteral(resourceName: "hlm_wallet_transfer"),#imageLiteral(resourceName: "hlm_wallet_money"),#imageLiteral(resourceName: "hlm_wallet_money")]
//        #imageLiteral(resourceName: "hlm_wallet_pay")
//        #imageLiteral(resourceName: "hlm_wallet_card")
        let btnNameArr = ["转账","余额","记录"]
//        ,"付款","储值卡"
        let btnColorArr = [UIColor(red: 0.8669, green: 0.699, blue: 0.2492, alpha: 1),UIColor(red: 0.2192, green: 0.6972, blue: 0.8682, alpha: 1),UIColor(red: 0.0, green: 0.7551, blue: 0.657, alpha: 1),UIColor(red: 0.952, green: 0.3037, blue: 0.3309, alpha: 1),UIColor(red: 0.952, green: 0.3037, blue: 0.3309, alpha: 1)]
        let wid = (kScreenW-WID*3)/2
        let hei = kScreenW*61/165
        
        for i in 0..<btnImageArr.count {
            
            let x = i%2
            let y = i/2
            
            let btn = HLTopBtn(frame: CGRect(x: WID + (wid+WID) * CGFloat(x), y: WID/2 + (hei+WID/2) * CGFloat(y), width: wid, height: hei))
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            btn.backgroundColor = btnColorArr[i]
            btn.setImage(btnImageArr[i], for: .normal)
            btn.setTitle(btnNameArr[i], for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.titleLabel?.font = font(14)
            btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
            btn.tag = i + 1
            view.addSubview(btn)
        }
        
    }
    
    func btnAction(btn: UIButton) -> Void {
        switch btn.tag {
        case 1:
            let vc = TransferAccountsVC()
            self.navigationController?.pushViewController(vc, animated: true)
//        case 2:
//            let vc = XSVirtualMemberCardViewController()
//            vc.getCodeBlock = {[weak self] in
//                self!.getCode()
//            }
//            vc.loadScanDataFromServiceBlock = {[weak self] code in
//                self!.loadScanDataFromService(code: code!)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 3:
//            let vc = WalletValueCardVC()
//            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = WalletAccountBalanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = WalletRecordVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func getCode() -> Void{
        
        let parameter = ["name":"{\"UserId\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\",\"app_system\":\"\(UIDevice.current.systemName)\",\"app_version\":\"\(UIDevice.current.systemVersion)\",\"number\":\"null\"}"]
        
        AlamofireNetWork.required(urlString: "/Simple_online/GetCode", method: .post, parameters: parameter, success: { (results) in
            
            let json = JSON(results)
            
            if json["resultStatus"] == 1 {
                let code = json["paycode"].int!
                let dic = ["state":"1","code":"\(code)"]
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RoloadWalletCodeNotification"), object: nil, userInfo: dic)
            }else{
                let dic = ["state":"0","data":"请求出错"]
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RoloadWalletCodeNotification"), object: nil, userInfo: dic)
            }
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "")
            let dic = ["state":"0","data":"无网络服务"]
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RoloadWalletCodeNotification"), object: nil, userInfo: dic)
        })
    }
    
    func loadScanDataFromService(code: String) -> Void{
        
        let parameter = ["data":"{\"paycode\":\"\(code)\"}"]
        
        AlamofireNetWork.required(urlString: "/Simple_online/WalletYesOrNo", method: .post, parameters: parameter, success: { (results) in
            
            let json = JSON(results)
            
            let code = json["PayCode"].int ?? 0
            let dic = ["state":"1","code":"\(code)"]
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "LoadScanDataFromServiceNotification"), object: nil, userInfo: dic)
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "")
            let dic = ["state":"0","data":"无网络服务"]
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "LoadScanDataFromServiceNotification"), object: nil, userInfo: dic)
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
