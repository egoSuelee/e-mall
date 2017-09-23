
//
//  ShopCartSetmentView.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 11/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

typealias  InfoClosure = ()->(totalPrice:String, freight:String)
typealias  ClickVoidClosure = () -> Void
typealias  CheckClosure = (_ isChecked:Bool) -> Void

class ShopCartSetmentView: UIView {

    
    var setClickClosure:ClickVoidClosure?
    var checkClosure:CheckClosure?
    
    dynamic var isChecked:Bool  = true { //isCheck==true -> all else none
        didSet {
            if isChecked {
                checkBtn.setImage(UIImage.init(named: "hlm_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                checkBtn.setImage(UIImage.init(named: "hlm_disSelected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    lazy var leftboxView = {UIView.init()}()
    lazy var rightBoxView = {UIView.init()}()
    
    lazy var checkBtn = {()->UIButton in
        let btn = UIButton.init(type:.system)
        btn.setImage(UIImage.init(named: "hlm_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(chooseAllItems), for: .touchUpInside)
        return btn
    }()
    
    func chooseAllItems() {
        isChecked = !isChecked
        if  let checkClosure = checkClosure {
            checkClosure(self.isChecked)
        }
    }
    
    lazy var totalPriceLabel = { () -> UILabel in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(gray: 16)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    lazy var freightLabel = { () -> UILabel in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.init(gray: 16)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    lazy var setMentBtn = {() -> UIButton in
        let btn = UIButton.init(type:.system)
        btn.setTitle("结算", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.backgroundColor = UIColor.init(r: 252, g: 12, b: 12)
        btn.setTitleColor(UIColor.white, for: .normal)
        
        return btn
    }()
    
   var infoClosure:InfoClosure?
    
    init(frame: CGRect, totalPrice:String) {
        super.init(frame: frame)
        
        self.addSubview(leftboxView)
        self.addSubview(rightBoxView)
        self.leftboxView.addSubview(totalPriceLabel)
        self.leftboxView.addSubview(checkBtn)
        self.rightBoxView.addSubview(setMentBtn)
    
    
    setMentBtn.addTarget(self, action: #selector(clickForPayAction), for: .touchUpInside)
    
    if infoClosure != nil {
        self.totalPriceLabel.text = "合计:\(infoClosure!().totalPrice)元"
    } else {
        self.totalPriceLabel.text = "合计:\(totalPrice)元"
        if totalPrice == "0" {
            setMentBtn.isEnabled = false
            setMentBtn.alpha = 0.6
        }else{
            setMentBtn.isEnabled = true
            setMentBtn.alpha = 1
        }
    }
    
    //MARK: --- 获取通知
    let notificationName = Notification.Name(rawValue: "valueChangedNotification")
    NotificationCenter.default.addObserver(self,selector:#selector(valueChanged(notification:)), name: notificationName, object: nil)

    let notificationName2 = Notification.Name(rawValue: "SlectedIndexChanged")
    NotificationCenter.default.addObserver(self, selector: #selector(indexsChanged(notification:)), name: notificationName2, object: nil)
    
    }
    
    func valueChanged(notification:NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let totalMoney = userInfo["totalMoney"] as! String
        self.totalPriceLabel.text = "合计:\(totalMoney)元"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func indexsChanged(notification:NSNotification) {
        let userInfo = notification.userInfo as! [String:Bool]
        let isempty:Bool = userInfo["isempty"]!
        let isequal:Bool = userInfo["isequal"]!
        
        if isempty {
            self.setMentBtn.isEnabled = false
            self.setMentBtn.alpha = 0.6
        } else {
            self.setMentBtn.isEnabled = true
            self.setMentBtn.alpha = 1
        }
        self.isChecked = isequal
    }
    
    func clickForPayAction() {
        if setClickClosure != nil {
            setClickClosure!()
        }
    }
    
    override func layoutSubviews() {
        leftboxView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(rightBoxView.snp.left)
        }
        
        checkBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        totalPriceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.left.equalTo(checkBtn.snp.right).offset(5)
            //make.top.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
        /*
        freightLabel.snp.makeConstraints { (make) in
            make.width.right.height.equalTo(totalPriceLabel)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(totalPriceLabel.snp.bottom).offset(5)
            
        }
        */
        rightBoxView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(leftboxView).multipliedBy(0.5)
        }
        
        setMentBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
