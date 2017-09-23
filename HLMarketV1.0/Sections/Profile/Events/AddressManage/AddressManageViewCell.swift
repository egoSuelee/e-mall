//
//  AddressManageViewCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 11/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit


typealias VoidClouser = (_ cellID:Int, _ btn: UIButton)->Void

enum AddressManageViewCellType {
    case showCheckBtn
    case hideCheckBtn
}


protocol AddressManageViewCellDelegate {
    func deleteAdress(sender:UIButton, cellID:Int)
    func editAddress(sender:UIButton, cellID:Int)
}

class AddressManageViewCell: UITableViewCell {

    var cellID:Int = 0
    var clickDefaultBtnClosure:VoidClouser?
    var delegate:AddressManageViewCellDelegate?
    
    var isChoosed:Bool? {
        didSet {
            if isChoosed! {
                setDefaultBtn.setImage(UIImage.init(named: "hlm_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: .normal)
            } else {
                setDefaultBtn.setImage(UIImage.init(named: "hlm_disSelected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: .normal)
            }
        }
    }
    
    //MARK: --- topviewbox
    lazy var topViewBox = {UIView.init()}()
    
    lazy var addressFetureLabel = { () -> UILabel in
        let label = UILabel.init()
        label.layer.backgroundColor = UIColor.appTextMainColor().cgColor
        //label.layer.borderColor = UIColor.appMainColor().cgColor
        //label.layer.borderWidth = 1
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var usernameLabel = {() -> UILabel in
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var userPhoneLabel = { () -> UILabel in
        let label = UILabel.init()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    lazy var userAddressTF = { () -> UILabel in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var sepline = { () -> UILabel in
        let label = UILabel.init()
        label.backgroundColor = UIColor.init(gray: 188)
        return label
    }()
    
    
    //MARK: --- botViewBox
    
    lazy var botViewBox = {UIView.init()}()
    lazy var editBtn = { () -> UIButton in
        let btn = UIButton.init(type: .system)
        
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderColor = UIColor.init(gray: 152).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        
        btn.setTitle("编辑", for: .normal)
        btn.setTitleColor(UIColor.init(gray: 14), for: .normal)
        return btn
    }()
    lazy var deleteBtn = {() -> UIButton in
        let btn = UIButton.init(type: .system)
        
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderColor = UIColor.init(gray: 152).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.init(gray: 14), for: .normal)
        
        
        return btn
    }()
    lazy var setDefaultBtn = {() -> UIButton in
        let btn = UIButton.init(type: .system)
        btn.setImage(UIImage.init(named: "hlm_disSelected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: .normal)
        return btn
    }()
    lazy var setDefaultLabel = {() -> UILabel in
        let label = UILabel.init()
        label.text = "设为默认地址"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var botSepLabel = {() ->UILabel in
        let label = UILabel.init()
        label.backgroundColor = BGCOLOR
        return label
    }()
    
    var addressUserModel:AddressUserModel? {
        didSet{
            userPhoneLabel.text = addressUserModel?.Tel
            usernameLabel.text  = addressUserModel?.UserName
            userAddressTF.text  = addressUserModel?.UserTotalAdressInfo
            addressFetureLabel.text = addressUserModel?.label
        }
    }
    
    
    func editAction(sender:UIButton) {
        if let delegate = delegate {
            delegate.editAddress(sender: sender, cellID: cellID)
        }
    }
    
    func deleteAction(sender:UIButton) {
        if let delegate = delegate {
            delegate.deleteAdress(sender: sender, cellID: cellID)
        }
    }
    
    
     override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(topViewBox)
        self.contentView.addSubview(botViewBox)
        self.contentView.addSubview(botSepLabel)
        
        self.botViewBox.addSubview(editBtn)
        self.botViewBox.addSubview(deleteBtn)
        self.botViewBox.addSubview(setDefaultBtn)
        self.botViewBox.addSubview(setDefaultLabel)
        
        
        
        self.topViewBox.addSubview(addressFetureLabel)
        self.topViewBox.addSubview(usernameLabel)
        self.topViewBox.addSubview(userPhoneLabel)
        self.topViewBox.addSubview(userAddressTF)
        self.topViewBox.addSubview(sepline)
        
        deleteBtn.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
        
        
        setDefaultBtn.addTarget(self, action: #selector(setDefaultAction(sender:)), for: .touchUpInside)
        setDefaultBtn.tag = cellID
        
        //let tap = UITapGestureRecognizer.init(target: self, action: #selector(setDefaultAction))
        //setDefaultLabel.addGestureRecognizer(tap)
        
        //self.beColorful()
        self.backgroundColor = UIColor.white
    }
    
    func setDefaultAction(sender:UIButton) {
        if clickDefaultBtnClosure != nil {
            clickDefaultBtnClosure!(cellID, sender)
        }
    }
    
    func beColorful() {
        
        for view in self.contentView.subviews {
            view.backgroundColor = UIColor.randomColor()
        }
        
    }
    
    /*
    override var frame:CGRect{
        didSet {
            var newFrame = frame
                newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
    */
    
    override func layoutSubviews() {
        /*
        checkboxBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.width.height.equalTo(20)
        }
        */
        /*
        editBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
         */

        
        //MARK: --- topviewbox snp
        
        topViewBox.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            //make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(botViewBox.snp.height).multipliedBy(2)
        }
        
        addressFetureLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalToSuperview()
            make.width.equalTo(userPhoneLabel.snp.width)
            make.left.equalTo(addressFetureLabel.snp.right).offset(5)
            make.right.equalTo(userPhoneLabel.snp.left)
        }
        userPhoneLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(usernameLabel.snp.width)
            make.left.equalTo(usernameLabel.snp.right)
            make.top.right.equalToSuperview()
        }
        
        /*
        usernameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalToSuperview().dividedBy(2)
            make.left.top.equalToSuperview()
        }
        userPhoneLabel.snp.makeConstraints { (make) in
            make.height.width.equalTo(usernameLabel)
            make.right.top.equalToSuperview()
        }
        */
        userAddressTF.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.left.right.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
        }
        sepline.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        //MARK: --- botboxview snp
        botSepLabel.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        botViewBox.snp.makeConstraints { (make) in
            make.left.right.equalTo(topViewBox)
            make.top.equalTo(topViewBox.snp.bottom).offset(5)
            make.bottom.equalTo(botSepLabel.snp.top).offset(-3)
        }
        setDefaultBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
        setDefaultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(setDefaultBtn.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(setDefaultBtn)
            make.right.equalTo(editBtn.snp.left).offset(-2)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
            make.width.equalToSuperview().dividedBy(6)
        }
        editBtn.snp.makeConstraints { (make) in
            make.right.equalTo(deleteBtn.snp.left).offset(-15)
            make.top.bottom.width.equalTo(deleteBtn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
