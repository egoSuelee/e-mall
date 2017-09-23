//
//  WalletChangePassword.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class WalletChangePassword: BaseViewController,UITextFieldDelegate {
    
    
    lazy var topBoxView = {UIView.init()}()
    var verCode:String? = nil
    
    // --- Q: 如何获取点击获取验证码的按钮, 让每次发送之后, 按钮禁用60s
    lazy var verCodeTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 20)
        let label = UILabel.init(frame:rect)
        label.text = "验证码"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        let rightBoxRect = CGRect(x: 0, y: kScreenW - 150, width: 120, height: 20)
        let rightBoxView = UIView.init(frame:rightBoxRect)
        let sepLine      = UIView.init(frame:CGRect(x: 0, y: 0, width: 0.5, height: 20))
        sepLine.backgroundColor = UIColor.init(gray: 212)
        
        let getCodeBtn   = UIButton.init(type: UIButtonType.custom)
        getCodeBtn.tag = 10
        getCodeBtn.setTitle("获取验证码", for: UIControlState.normal)
        getCodeBtn.setTitleColor(UIColor.init(gray:168), for: UIControlState.normal)
        getCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        //点击按钮获取验证码
        getCodeBtn.addTarget(self, action: #selector(getCodeAction), for: UIControlEvents.touchUpInside)
        
        getCodeBtn.frame = CGRect(x: 0, y: 0, width: 118, height: 20)
        //布局 ----- snp
        
        
        rightBoxView.addSubview(sepLine)
        rightBoxView.addSubview(getCodeBtn)
        
        textfield.rightView = rightBoxView
        textfield.rightViewMode = UITextFieldViewMode.always
        
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请输入验证码"
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.font = UIFont.systemFont(ofSize: 14)
        
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    lazy var passwordTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 20)
        let label = UILabel.init(frame:rect)
        label.text = "密码"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        //定义textfield的样式
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请输入6位数字密码"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    lazy var password1TF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 20)
        let label = UILabel.init(frame:rect)
        label.text = "确认"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        //定义textfield的样式
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请再次输入密码"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    var codeIndex = 60
    
    var getCodeBtn = UIButton()
    
    lazy var botBoxView = {UIView.init()}()
    
    lazy var nextStepBtn = {() -> UIButton in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn.addTarget(self, action: #selector(doAction), for: UIControlEvents.touchUpInside)
        
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.backgroundColor = UIColor.appMainColor().cgColor
        
        return btn
    }()
    
    
    func getCodeAction() {
        
        passwordTF.resignFirstResponder()
        password1TF.resignFirstResponder()
        verCodeTF.resignFirstResponder()
        
        nextStepBtn.isUserInteractionEnabled = false
        getCodeBtn.isUserInteractionEnabled = false
        
        showHud(in: view)
        
        do {
            let pattern = "^1[0-9]{10}$"
            let validateString = UserAuthManager.sharedManager.getUserModel()!.UserNo
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            if matches.count > 0 {
                //进行网络请求, 发送验证码
                AlamofireNetWork.required(urlString: "/Simple_online/Get_TelPhone_Code", method: .post, parameters: ["Tel":"\(validateString)","reg_or_update":"1"], success: { [weak self] (results) in
                    
                    self?.nextStepBtn.isUserInteractionEnabled = true
                    
                    if "\(results["resultStatus"]!)"  == "000000" {
                        
                        self?.createTimer()
                        
                        self?.showHint(in: (self?.view)!, hint: "验证码已发送, 请注意查收")
                        self?.verCode = results["data"] as! String?
                    }else if "\(results["resultStatus"]!)" == "160040"{
                        self?.getCodeBtn.isUserInteractionEnabled = true
                        self?.showHint(in: (self?.view)!, hint: "此手机号超过当天发送上限")
                    }else{
                        self?.getCodeBtn.isUserInteractionEnabled = true
                        self?.showHint(in: (self?.view)!, hint: "验证码发送出错")
                    }
                    
                    }, failure: { (error) in
                        self.hideHud()
                        self.getCodeBtn.isUserInteractionEnabled = true
                        self.nextStepBtn.isUserInteractionEnabled = true
                })
                
            } else {
                self.getCodeBtn.isUserInteractionEnabled = true
                self.nextStepBtn.isUserInteractionEnabled = true
                showHint(in: view, hint: "验证码发送出错")
            }
        }
        catch {
            hideHud()
            getCodeBtn.isUserInteractionEnabled = true
            nextStepBtn.isUserInteractionEnabled = true
        }
    }
    
    func createTimer() -> Void {
        
        codeIndex = 60
        
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        timer.fire()
    }
    
    func timerAction() -> Void {
        if codeIndex == 0 {
            getCodeBtn.setTitle("获取验证码", for: .normal)
            getCodeBtn.isUserInteractionEnabled = true
            return
        }
        getCodeBtn.setTitle("(\(codeIndex)s后再次获取)", for: .normal)
        codeIndex -= 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(gray: 252)
        
        self.navigationItem.title = "修改支付密码"
        self.setupUI()
        self.layoutUI()
    }
    
    func doAction() {
        
        passwordTF.resignFirstResponder()
        password1TF.resignFirstResponder()
        verCodeTF.resignFirstResponder()
        
        guard passwordTF.text != "" && password1TF.text != "" else {
            showHint(in: self.view, hint: "密码不能为空")
            return
        }
        
        do {
            let pattern = "^[0-9]{6}$"
            let validateString = passwordTF.text!
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            if matches.count > 0 {
                
                guard passwordTF.text == password1TF.text else {
                    showHint(in: self.view, hint: "两次密码输入不一样")
                    return
                }
                
                let text = verCodeTF.text
                if text! == self.verCode {
                
                    AlamofireNetWork.required(urlString: "/Simple_online/Update_Wallet_Message", method: .post, parameters: ["UserNo":"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)","Password":"\(passwordTF.text!.md5String())","sing":"\((UserAuthManager.sharedManager.getUserModel()!.UserNo+passwordTF.text!.md5String()+"ware").md5String())"], success: { [weak self] (results) in
                        
                        self?.nextStepBtn.isUserInteractionEnabled = true
                        
                        if results["resultStatus"] as! String == "1" {
                            
                            self?.showHint(in: (self?.view)!, hint: "修改支付密码成功")
                            
                            DispatchQueue_AfterExecute(delay: 1, blok: { 
                                self?.navigationController?.popViewController(animated: true)
                            })
                            
                        }else{
                            self?.getCodeBtn.isUserInteractionEnabled = true
                            self?.showHint(in: (self?.view)!, hint: "修改支付密码失败")
                        }
                        
                        }, failure: { (error) in
                            self.hideHud()
                            self.getCodeBtn.isUserInteractionEnabled = true
                            self.nextStepBtn.isUserInteractionEnabled = true
                    })
                    
                    
                } else {
                    showHint(in: self.view, hint: "验证码不正确")
                }

            } else {
                showHint(in: self.view, hint: "密码必须为6位数字密码")
            }
        }
        catch {
            hideHud()
        }
        
    }
    
    func setupUI() {
        view.addSubview(topBoxView)
        topBoxView.addSubview(passwordTF)
        topBoxView.addSubview(password1TF)
        topBoxView.addSubview(verCodeTF)
        getCodeBtn = verCodeTF.rightView?.viewWithTag(10) as! UIButton
        passwordTF.delegate = self
        password1TF.delegate = self
        
        
        view.addSubview(botBoxView)
        botBoxView.addSubview(nextStepBtn)
        
    }
    
    func layoutUI() {
        
        topBoxView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.view).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(158)
        }
        
        verCodeTF.snp.makeConstraints { (make) in
            make.top.left.equalTo(topBoxView).offset(5)
            make.height.equalTo(passwordTF)
            make.right.equalTo(-5)
            make.bottom.equalTo(passwordTF.snp.top).offset(-5)
        }
        
        passwordTF.snp.makeConstraints { (make) in
            make.right.left.equalTo(verCodeTF)
            make.height.equalTo(password1TF)
            make.bottom.equalTo(password1TF.snp.top).offset(-5)
        }
        
        password1TF.snp.makeConstraints { (make) in
            //make.top.equalTo(userTF.snp.bottom).offset(5)
            make.bottom.equalTo(topBoxView.snp.bottom).offset(-5)
            make.left.right.equalTo(passwordTF)
        }
        
        botBoxView.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBoxView)
            make.width.equalTo(topBoxView)
            make.top.equalTo(topBoxView.snp.bottom).offset(10)
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        nextStepBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(botBoxView)
            make.width.equalTo(botBoxView).multipliedBy(0.8)
            make.top.equalTo(botBoxView).offset(5)
            make.height.equalTo(password1TF.snp.height)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == verCodeTF {
            passwordTF.becomeFirstResponder()
        }else if textField == passwordTF {
            password1TF.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


