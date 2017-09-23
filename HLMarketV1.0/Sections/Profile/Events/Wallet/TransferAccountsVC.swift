//
//  TransferAccountsVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/13.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

let private_key_string = "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALgv/syFH337KzC29KvR0p6cP+glRqjDYAQno5ifafXZjgf1EhBjZblKv+HiLAzNBOlYU1PnLuOOkZj6pg1A5HUZLpsbYa5Mwr1bUHALjXLaB3THCpZX51/b5L14erGo52Jv/j/63YljEtMm8ALmkY8S+3fPxFeY7ya+2VXMEtplAgMBAAECgYAguvauZWGpQ37zUy+7cLfa061PlYAu8TkYw+qAbqOnupdQtq4VF3S2LqBWhZiKVcxvovB70nM0oNsisjfb1xJBpyfDBFug7d+y2f8yr6aTOezoY5DBYEF3Svg9Kp9ra+vvAYX/7fh+tHCU0HOvp0z8ikZiRSWZaQ+3A2GiCIJrwQJBAPKVji89hGAMEWLJJFZaPiLBqZUwR2W/rp7Ely5ddKfjcosHhggHfOb71BnrMOm0h4S85Gx6a87n9R2To0c51q0CQQDCX6yYdt/9JGORyNSXfzMfSZyVOrMpIo77R0YwKa3UOwwLA56l2Lc4AYO10/lyAyZCKse2/5D9ZZUB7xoYEmGZAkB8MEJVPuoY/bSc3RqENrjetERsAwZaObJcx4oaC3AgTxmhwV1FmQfBfKTODBDDZE+Ijedm/ZlZmHhtBtstKJgVAkBKma/DgHRtUscIT90QHBjB3F3FhJb4pbPcyzksCQMXXmY73/LG0ktXqnUjlyy4zm6jnIm0OZgrOQ6chGkubfeZAkBMCGF2tPfEJh8XODOvlw5ADnUiq+Qe/abcpKowkiT9zP+rYT9XJAx7QxChjdwTZb6ahnJY1+ny1emEHUOs2fm8"

let public_key_string = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4L/7MhR99+yswtvSr0dKenD/oJUaow2AEJ6OYn2n12Y4H9RIQY2W5Sr/h4iwMzQTpWFNT5y7jjpGY+qYNQOR1GS6bG2GuTMK9W1BwC41y2gd0xwqWV+df2+S9eHqxqOdib/4/+t2JYxLTJvAC5pGPEvt3z8RXmO8mvtlVzBLaZQIDAQAB"

class TransferAccountsVC: BaseViewController,UITextFieldDelegate {
    
    fileprivate var publicKey = ""
    
    fileprivate var acountArr = [String:String]()
    
    fileprivate var psw = ""
    
    lazy var topBoxView = {UIView.init()}()
    
    lazy var userTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 20)
        let label = UILabel.init(frame:rect)
        label.text = "账号"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        //定义textfield的样式
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请输入对方手机号"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.clearButtonMode = UITextFieldViewMode.always
        
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    lazy var moneyTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 20)
        let label = UILabel.init(frame:rect)
        label.text = "金额"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        //定义textfield的样式
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请输入转账金额"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.clearButtonMode = UITextFieldViewMode.always
        
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    lazy var botBoxView = {UIView.init()}()
    
    lazy var doBtn = {() -> UIButton in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.backgroundColor = UIColor.appMainColor().cgColor
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "转账"
        
        doBtn.addTarget(self, action: #selector(checkout), for: .touchUpInside)

        setupUI()
        layoutUI()
    }
    // MARK: -- 校验账号
    func checkout() -> Void {
        
        self.userTF.resignFirstResponder()
        self.moneyTF.resignFirstResponder()

        showHud(in: view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/Authentication", method: .post, parameters: ["name":"{\"Tel\":\"\(userTF.text!)\"}"], success: { (results) in
            
            let json = JSON(results)
            
            if json["resultStatus"] == 1 {
                
                self.hideHud()
                
                self.acountArr = json["dDate"].dictionaryObject as! [String : String]
                
                let zc = ZCTradeView()
                zc.finish = { [weak self] psw in
                    self?.psw = psw!
                    self?.getKEY()
                }
                zc.show()
                
            }else{
                self.showHint(in: self.view, hint: "该账号未注册")
            }
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
        
    }
    // MARK: -- 获取公钥
    func getKEY() -> Void {
        
        showHud(in: view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/KEY", method: .get, parameters: nil, success: { (results) in

            let json = JSON(results)
            
            self.publicKey = json["resultStatus"].string!
            
            self.doBtnAction()
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
        
    }
    // MARK: -- 转账
    func doBtnAction() -> Void {
        
        let handler = HBRSAHandler()
        handler.importKey(with: KeyTypePrivate, andPath: private_key_string)
        handler.importKey(with: KeyTypePublic, andPath: public_key_string)
        
        let str = "{\"In_ID\":\"\(acountArr["Buyer_id"]!)\",\"In_Name\":\"\(acountArr["BuyerName"]!)\",\"Out_ID\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\",\"Out_Name\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\",\"Pass\":\"\(self.psw.md5String())\",\"WTransfer_Money\":\"\(String.init(format: "%0.2f", Float(Double(moneyTF.text!)!)))\"}"
        
        let sign = RSAObject.encryptString(str, publicKey: publicKey)
        
        let parameter = ["name":"{\"device\":\"iOS\",\"PublicKey\":\"\(public_key_string)\",\"sign\":\"\(sign!)\",\"signgg\":\"\(handler.signMD5String(sign!))\"}"]
        
        AlamofireNetWork.required(urlString: "/Simple_online/Transfermoney", method: .post, parameters: parameter, success: { (results) in
            
            let json = JSON(results)
            
            var str = ""
            switch json["resultStatus"] {
            case -2:
                str="支付信息遭到篡改"
            case -1:
                str="支付密码错误"
            case 0:
                str="转账异常"
            case 1:
                str="转账成功"
            case 2:
                str="余额不足"
            case 3:
                str="转账用户信息有误"
            case 4:
                str="接收转账用户信息有误"
            case 5:
                str="不能给自己转账"
                
            default:
                break;

            }
            
            self.showHint(in: self.view, hint: str)
            
            if str == "转账成功" {
                self.userTF.text = ""
                self.moneyTF.text = ""
                self.psw = ""
                self.publicKey = ""
            }
            
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
        
    }
    
    func setupUI() {
        view.addSubview(topBoxView)
        topBoxView.addSubview(userTF)
        userTF.delegate = self
        topBoxView.addSubview(moneyTF)
        moneyTF.delegate = self
        
        view.addSubview(botBoxView)
        botBoxView.addSubview(doBtn)
    }
    
    func layoutUI() {
        
        topBoxView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.view).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(108)
        }
        
        userTF.snp.makeConstraints { (make) in
            make.top.left.equalTo(topBoxView).offset(5)
            make.height.equalTo(moneyTF)
            make.right.equalTo(-5)
            make.bottom.equalTo(moneyTF.snp.top).offset(-5)
        }
        
        moneyTF.snp.makeConstraints { (make) in
            make.top.equalTo(userTF.snp.bottom).offset(5)
            make.left.right.equalTo(userTF)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        botBoxView.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBoxView)
            make.width.equalTo(topBoxView)
            make.top.equalTo(topBoxView.snp.bottom).offset(10)
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        doBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(botBoxView)
            make.width.equalTo(botBoxView).multipliedBy(0.8)
            make.top.equalTo(botBoxView).offset(5)
            make.height.equalTo(userTF.snp.height)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTF {
            moneyTF.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
