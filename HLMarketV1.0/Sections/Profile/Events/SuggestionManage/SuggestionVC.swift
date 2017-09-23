//
//  SuggestionVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 07/04/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class SuggestionVC: BaseViewController {

    var textViewInfoLabel  = UILabel()
    var textFieldInfoLabel  = UILabel()
    var textField  = UITextField()
    var textBoxView = UIView()
    var text1BoxView = UIView()
    var textView = UITextView()
    var commitBtn = HighLightedBtn.init(frame: CGRect.zero, 0xff3951)
    
    var appVersion:String?
    var suggetions:String?
    
    var offset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "意见反馈"
        setupUI()
    }

    func setupUI() {
        self.view.addSubview(textBoxView)
        self.view.backgroundColor = BGCOLOR
        textBoxView.addSubview(textView)
        self.view.addSubview(text1BoxView)
        text1BoxView.addSubview(textField)
        
        self.view.addSubview(textViewInfoLabel)
        self.view.addSubview(textFieldInfoLabel)
        self.view.addSubview(commitBtn)
        
    
        textViewInfoLabel.text = "意见或者建议反馈*"
        textViewInfoLabel.textColor = UIColor.init(gray: 121)
        textViewInfoLabel.font = font(12)
        textViewInfoLabel.textAlignment = .left
        
        textFieldInfoLabel.text = "联系方式*（选填）"
        textFieldInfoLabel.textColor = UIColor.init(gray: 121)
        textFieldInfoLabel.font = font(12)
        textFieldInfoLabel.textAlignment = .left
        
        textBoxView.layer.backgroundColor = UIColor.white.cgColor
        textBoxView.layer.borderColor = UIColor.init(gray: 232).cgColor
        textBoxView.layer.borderWidth = _1pxWidth
        
        text1BoxView.layer.backgroundColor = UIColor.white.cgColor
        text1BoxView.layer.borderColor = UIColor.init(gray: 232).cgColor
        text1BoxView.layer.borderWidth = _1pxWidth
        
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.textColor = UIColor.init(gray: 33)
        textField.font = font(16)
        textField.delegate = self
        
        textView.layer.backgroundColor = UIColor.white.cgColor
        textView.textColor = UIColor.init(gray: 33)
        textView.font = font(16)
        textView.delegate = self
        
        //commitBtn.layer.borderWidth = _1pxWidth
        //commitBtn.layer.backgroundColor = UIColor.appTextMainColor().cgColor
        commitBtn.layer.cornerRadius = 3
        commitBtn.layer.masksToBounds = true
        //commitBtn.layer.borderColor = UIColor.deeperAppColor().cgColor
        commitBtn.setTitleColor(UIColor.white, for: .normal)
        commitBtn.setTitle("提交反馈", for: .normal)
        commitBtn.addTarget(self, action: #selector(commitAction), for: .touchUpInside)
        
        textViewInfoLabel.snp.makeConstraints { (make) in
            //make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(HEI)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
        }
        
        textBoxView.snp.makeConstraints { (make) in
            make.top.equalTo(textViewInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(150)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 6, 5, 6))
        }
        
        textFieldInfoLabel.snp.makeConstraints { (make) in
            //make.centerY.equalToSuperview()
            make.top.equalTo(textBoxView.snp.bottom).offset(HEI)
            make.height.equalTo(HEI)
            make.left.right.equalTo(textViewInfoLabel)
        }
        
        text1BoxView.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        textField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 6, 5, 6))
        }
        
        commitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(text1BoxView.snp.bottom).offset(HEI)
            make.left.equalToSuperview().offset(2*WID)
            make.right.equalToSuperview().offset(-2*WID)
            make.height.equalTo(commitBtn.snp.width).dividedBy(7)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func commitAction() {
        if textView.text.characters.count < 15 {
            showHint(in: self.view, hint: "至少15个字")
            return
        }
        self.suggetions = textView.text
        
        if var suggetions = self.suggetions {
            
            if let suggetions1 = textField.text, textField.text?.characters.count != 0 {
                suggetions += "  联系方式:\(suggetions1)"
            }
            
            AlamofireNetWork.required(urlString: "/Simple_online/User_Suggestion", method: .post, parameters: ["UserNo":(UserAuthManager.sharedManager.getUserModel()?.UserNo)!, "Suggestions":suggetions], success: { (result) in
                self.showHint(in: self.view, hint: "成功提交, 感谢您的反馈")
                DispatchQueue_AfterExecute(delay: 1.5, blok: {
                    self.navigationController?.popViewController(animated: true)
                })
            }, failure: { (error) in
                self.showHint(in: self.view, hint: "网络出现问题.")
            })
            
        }
        
    }
}

extension SuggestionVC:UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textView.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setViewUPOrDown(up: false)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func setViewUPOrDown(up: Bool) -> Void {
        
        UIView.animate(withDuration: 0.3) { 
            if up {
                self.view.y = self.offset
            }else{
                self.view.y = 64
            }
        }
    }
    
    func keyboardWillHide(nofi: Notification) -> Void {
        guard self.view.y != offset else {
            setViewUPOrDown(up: false)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(nofi:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension SuggestionVC:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        offset = self.view.height - (commitBtn.bottom+216)
        if offset<0 {
            setViewUPOrDown(up: true)
        }else{
            setViewUPOrDown(up: false)
        }
        return true
    }
}
