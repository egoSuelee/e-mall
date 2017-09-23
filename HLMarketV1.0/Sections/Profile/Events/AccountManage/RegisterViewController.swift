//
//  RegisterViewController.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 10/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit



class RegisterViewController: BaseViewController,UITextFieldDelegate {
    
    lazy var topBoxView = {UIView.init()}()
    var verCode:String? = nil
    
    lazy var phoneTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 20)
        let label = UILabel.init(frame:rect)
        label.text = "手机号"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        //定义textfield的样式
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请输入手机号"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.clearButtonMode = UITextFieldViewMode.always
        
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    // --- Q: 如何获取点击获取验证码的按钮, 让每次发送之后, 按钮禁用60s
    lazy var verCodeTF: UITextField = { [weak self] in
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
        getCodeBtn.addTarget(self, action: #selector(RegisterViewController.getCodeAction), for: UIControlEvents.touchUpInside)
        
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
    
    var codeIndex = 60
    
    var getCodeBtn = UIButton()
    
    lazy var botBoxView = {UIView.init()}()
    
    lazy var botBoxTopView = {UIView.init()}()
    
    lazy var selectedBtn: UIButton = { [weak self] in
        let btn = HLP_MiniImageSizeBtn.image(scale: 0.6)
        btn.setImage(UIImage.init(named: "未选中"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(selectedBtnAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    var selectedBtnState: Bool = false {
        didSet{
            switch selectedBtnState {
            case true:
                selectedBtn.setImage(UIImage.init(named: "选中"), for: UIControlState.normal)
            default:
                selectedBtn.setImage(UIImage.init(named: "未选中"), for: UIControlState.normal)
            }
        }
    }
    
    lazy var serviceBtn: UIButton = { [weak self] in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("同意\"乐家优鲜服务协议\"", for: UIControlState.normal)
        btn.setTitleColor( UIColor.lightGray, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(serviceBtnAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var nextStepBtn: UIButton = { [weak self] in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("下一步", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn.addTarget(self, action: #selector(RegisterViewController.nextRegisterAction), for: UIControlEvents.touchUpInside)
        
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.backgroundColor = UIColor.appMainColor().cgColor
        
        return btn
    }()
    
    func getCodeAction() {
        
        phoneTF.resignFirstResponder()
        verCodeTF.resignFirstResponder()
        
        nextStepBtn.isUserInteractionEnabled = false
        getCodeBtn.isUserInteractionEnabled = false
        
        showHud(in: view)
        
        do {
            let validateString = phoneTF.text!
            let regex: NSRegularExpression = try NSRegularExpression(pattern: PHONE_REG_PATTERN, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            if matches.count > 0 {
                //进行网络请求, 发送验证码
                AlamofireNetWork.required(urlString: "/Simple_online/Get_TelPhone_Code", method: .post, parameters: ["Tel": validateString, "reg_or_update":"0","cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { [weak self] (results) in
                    
                    self?.nextStepBtn.isUserInteractionEnabled = true
                    
                    if results["resultStatus"] as! String == "000000" {
                        
                        self?.createTimer()
                        
                        self?.showHint(in: (self?.view)!, hint: "验证码已发送, 请注意查收")
                        self?.verCode = results["dDate"] as! String?
                    }else if results["resultStatus"] as! String == "0" {
                        self?.getCodeBtn.isUserInteractionEnabled = true
                        self?.showHint(in: (self?.view)!, hint: "此用户已经注册")
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
                showHint(in: view, hint: "请输入正确的手机号")
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
    
    func selectedBtnAction() {
        self.selectedBtnState = !self.selectedBtnState
    }
    
    func serviceBtnAction() {
        let serviceVC = ServiceAgreementVC.init(nibName: "ServiceAgreementVC", bundle: nil)
        self.navigationController?.pushViewController(serviceVC, animated: true)
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
        
        self.navigationItem.title = "注册"
        self.setupUI()
        self.layoutUI()
    }
    
    func nextRegisterAction() {
        
        phoneTF.resignFirstResponder()
        verCodeTF.resignFirstResponder()
        
        guard self.selectedBtnState else {
            showHint(in: self.view, hint: "请点击同意乐家优鲜服务协议")
            return
        }
        
        let text = verCodeTF.text
        if text! == self.verCode {
            let nextRegisterVC = NextRegisterVC()
            nextRegisterVC.tel = phoneTF.text!
            
            self.navigationController?.pushViewController(nextRegisterVC, animated: true)
        } else {
            showHint(in: self.view, hint: "验证码不正确")
        }
    }

    func setupUI() {
        view.addSubview(topBoxView)
        topBoxView.addSubview(phoneTF)
        topBoxView.addSubview(verCodeTF)
        getCodeBtn = verCodeTF.rightView?.viewWithTag(10) as! UIButton
        phoneTF.delegate = self
        verCodeTF.delegate = self
        
        view.addSubview(botBoxView)
        botBoxView.addSubview(botBoxTopView)
        botBoxTopView.addSubview(selectedBtn)
        botBoxTopView.addSubview(serviceBtn)
        botBoxView.addSubview(nextStepBtn)
        
    }
    
    func layoutUI() {
        
        topBoxView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.view).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(108)
        }
        
        phoneTF.snp.makeConstraints { (make) in
            make.top.left.equalTo(topBoxView).offset(5)
            make.height.equalTo(verCodeTF)
            make.right.equalTo(-5)
            make.bottom.equalTo(verCodeTF.snp.top).offset(-5)
        }
        
        verCodeTF.snp.makeConstraints { (make) in
            //make.top.equalTo(userTF.snp.bottom).offset(5)
            make.bottom.equalTo(topBoxView.snp.bottom).offset(-5)
            make.left.right.equalTo(phoneTF)
            make.height.equalTo(phoneTF)
        }
        
        botBoxView.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBoxView)
            make.width.equalTo(topBoxView)
            make.top.equalTo(topBoxView.snp.bottom).offset(10)
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        botBoxTopView.snp.makeConstraints { (make) in
            make.centerX.equalTo(botBoxView)
            make.width.equalTo(200)
            make.top.equalTo(botBoxView)
            make.height.equalTo(30)
        }
        
        selectedBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(serviceBtn.snp.left)
            make.width.equalTo(30)
        }
        
        serviceBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
        }
        
        nextStepBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(botBoxView)
            make.width.equalTo(botBoxView).multipliedBy(0.8)
            make.top.equalTo(botBoxTopView.snp.bottom).offset(5)
            make.height.equalTo(phoneTF.snp.height)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTF {
            verCodeTF.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
