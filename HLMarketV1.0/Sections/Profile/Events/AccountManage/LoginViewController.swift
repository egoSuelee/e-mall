//
//  RegisterViewController.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 10/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: BaseViewController,UITextFieldDelegate {
    
    lazy var topBoxView = {UIView.init()}()
    var autoLoginDicSetting:Dictionary<String, Any>? {
        didSet {
            if let autoLoginDicSetting = autoLoginDicSetting {
                autoLoginAction(dic: autoLoginDicSetting)
            }
        }
    }
    
    
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
        textfield.placeholder = "请输入用户名"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.clearButtonMode = UITextFieldViewMode.always
        
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    lazy var pwdTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 20)
        let label = UILabel.init(frame:rect)
        label.text = "密码"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请输入密码"
        textfield.isSecureTextEntry = true
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.font = UIFont.systemFont(ofSize: 14)
        
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    lazy var botBoxView = {UIView.init()}()
    
    lazy var loginBtn = {() -> UIButton in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.backgroundColor = UIColor.appMainColor().cgColor
        
        return btn
    }()
    
    lazy var forgotBtn: UIButton = { [weak self] in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle(" 忘记密码? ", for: UIControlState.normal)
        btn.setTitleColor(UIColor.init(gray: 168), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(forgetPwdAction), for: .touchUpInside)
    
        return btn
    }()
    
    func forgetPwdAction() {
        self.userTF.resignFirstResponder()
        self.pwdTF.resignFirstResponder()
        let forgetVC = ForgetPwdVC()
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(gray: 252)
        
        self.navigationItem.title = "登录"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginViewController.registerAction))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.appNavBarTitleColor()
   
        //MARK: --- 登录按钮添加点击事件
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        self.setupUI()
        self.layoutUI()
    }
    
    
    
    func autoLoginAction(dic:Dictionary<String, Any>) {
       
            showHud(in: view)
            
            AlamofireNetWork.required(urlString: "/Simple_online/User_Log_in", method: .post, parameters: ["UserNo":dic["Tel"] as! String,"Pass":dic["PassWord"] as! String,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (results) in
                
                let json = JSON(results)
                
                if json["resultStatus"] == "1" {
                    let dictObj = json["dDate"].dictionaryObject
                    let userModel = UserAuthModel.init()
                    if dictObj?["UserNo"] != nil {
                        userModel.UserNo = dictObj?["UserNo"] as! String
                    }
                    if dictObj?["ImagePath"] != nil {
                        userModel.UserIcon = dictObj?["ImagePath"] as! String
                    }
                    if dictObj?["cStoreNo"] != nil {
                        userModel.cStoreNo = dictObj?["cStoreNo"] as! String
//                        UserStoreManager.sharedManager.save(storeNo: userModel.cStoreNo)
//                        UserStoreManager.sharedManager.saveStoreName(storeName: "")
                        //MARK: --- 发送通知告诉购物车, 以及搜索页面刷新数据
                        NotificationCenter.default.post(name: NotiNameOfAfterChooseStore, object: self, userInfo: [:])
                    }
                    UserAuthManager.sharedManager.saveUserInfo(userModel: userModel)
                    
                    DispatchQueue.main.async(execute: {
                        _ = self.navigationController?.popViewController(animated:true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: userLoginOutActionNoficition), object: self,userInfo: ["UserActionType":HLUserAction.logIn])
                    })
                }else{
                    self.showHint(in: self.view, hint: "账号/密码错误")
                }
                
                
            }, failure: { (error) in
                self.hideHud()
            })
        

    }
    
    
    func loginAction() {
        
        userTF.resignFirstResponder()
        pwdTF.resignFirstResponder()
        
        if userTF.text == "" || pwdTF.text == "" {
            showHint(in: view, hint: "用户名/密码不能为空")
        } else {
            
            loginBtn.isUserInteractionEnabled = false
            
            showHud(in: view)
            
            AlamofireNetWork.required(urlString: "/Simple_online/User_Log_in", method: .post, parameters: ["UserNo":userTF.text!,"Pass":pwdTF.text!.md5String(),"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (results) in
                
                let json = JSON(results)
                
                if json["resultStatus"] == "1" {
                    let dictObj = json["dDate"].dictionaryObject
                    let userModel = UserAuthModel.init()
                    if dictObj?["UserNo"] != nil {
                        userModel.UserNo = dictObj?["UserNo"] as! String
                    }
                    if dictObj?["ImagePath"] != nil {
                        userModel.UserIcon = dictObj?["ImagePath"] as! String
                    }
                    if dictObj?["cStoreNo"] != nil {
                        userModel.cStoreNo = dictObj?["cStoreNo"] as! String
//                         UserStoreManager.sharedManager.save(storeNo: userModel.cStoreNo)
//                         UserStoreManager.sharedManager.saveStoreName(storeName: "")
                        //MARK: --- 发送通知告诉购物车, 以及搜索页面刷新数据
                        NotificationCenter.default.post(name: NotiNameOfAfterChooseStore, object: self, userInfo: [:])
                    }
                   UserAuthManager.sharedManager.saveUserInfo(userModel: userModel)
                    
                    DispatchQueue.main.async(execute: {
                       _ = self.navigationController?.popViewController(animated:true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: userLoginOutActionNoficition), object: self,userInfo: ["UserActionType":HLUserAction.logIn])
                    })
                }else{
                    self.showHint(in: self.view, hint: "账号/密码错误")
                }
                
                self.loginBtn.isUserInteractionEnabled = true
                
            }, failure: { (error) in
                self.hideHud()
                self.loginBtn.isUserInteractionEnabled = true
            })
        }
        
    }
    
    func registerAction() {
        
        self.userTF.resignFirstResponder()
        self.pwdTF.resignFirstResponder()
        
        if UserAuthManager.sharedManager.isUserLogin() {
            showHint(in: view, hint: "亲>已经登录啦!")
            return
        }
        
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
    func setupUI() {
        view.addSubview(topBoxView)
        topBoxView.addSubview(userTF)
        userTF.delegate = self
        topBoxView.addSubview(pwdTF)
        pwdTF.delegate = self
        
        view.addSubview(botBoxView)
        botBoxView.addSubview(loginBtn)
        botBoxView.addSubview(forgotBtn)
    }
    
    func layoutUI() {
        
        topBoxView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.view).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(108)
        }
        
        userTF.snp.makeConstraints { (make) in
            make.top.left.equalTo(topBoxView).offset(5)
            make.height.equalTo(pwdTF)
            make.right.equalTo(-5)
            make.bottom.equalTo(pwdTF.snp.top).offset(-5)
        }
        
        pwdTF.snp.makeConstraints { (make) in
            //make.top.equalTo(userTF.snp.bottom).offset(5)
            make.bottom.equalTo(topBoxView.snp.bottom).offset(-5)
            make.left.right.equalTo(userTF)
            make.height.equalTo(userTF)
        }
        
        botBoxView.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBoxView)
            make.width.equalTo(topBoxView)
            make.top.equalTo(topBoxView.snp.bottom).offset(10)
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(botBoxView)
            make.width.equalTo(botBoxView).multipliedBy(0.8)
            make.top.equalTo(botBoxView).offset(5)
            make.height.equalTo(userTF.snp.height)
        }
        
        forgotBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(2)
            make.right.equalTo(loginBtn.snp.right)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTF {
            pwdTF.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
