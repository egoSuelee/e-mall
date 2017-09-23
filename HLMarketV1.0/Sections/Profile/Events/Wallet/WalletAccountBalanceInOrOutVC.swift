//
//  WalletAccountBalanceInOrOutVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/13.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class WalletAccountBalanceInOrOutVC: BaseViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var reloadPriceLabel: (() -> ())?
    
    lazy var dataArr = [[String:Any]]()
    
    lazy var currentIndexPath = IndexPath(row: 0, section: 0)
    
    lazy var grayView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-64))
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    lazy var topBoxView = {UIView.init()}()
    
    lazy var cartBtn = {() -> UIButton in
        let btn = UIButton.init()
        btn.layer.borderColor = UIColor.init(gray: 234).cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("---", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.white
        return btn
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
        
        self.cartBtn.addTarget(self, action: #selector(cartBtnAction), for: .touchUpInside)
        self.doBtn.addTarget(self, action: #selector(doBtnAction), for: .touchUpInside)

        self.setupUI()
        self.layoutUI()
        
        self.getCartData()
    }
    // MARK: -- 显示、隐藏tableView
    func showTableView() -> Void {
        grayView.isHidden = false
        let hei = Float(dataArr.count*44)
        let x = self.topBoxView.frame.minX+self.cartBtn.frame.minX
        let y = self.topBoxView.frame.minY+self.cartBtn.frame.maxY
        let width = self.cartBtn.width
        
        UIView.animate(withDuration: 0.5) { 
            self.tableView.frame = CGRect(x: x, y: y, width: width, height: CGFloat(hei/3))
            self.tableView.frame = CGRect(x: x, y: y, width: width, height: CGFloat(hei*2/3))
            self.tableView.frame = CGRect(x: x, y: y, width: width, height: CGFloat(hei))
        }
        
    }
    func hideTableView() -> Void {
        let hei = Float(dataArr.count*44)
        let x = self.topBoxView.frame.minX+self.cartBtn.frame.minX
        let y = self.topBoxView.frame.minY+self.cartBtn.frame.maxY
        let width = self.cartBtn.width
        UIView.animate(withDuration: 0.5, animations: { 
            self.tableView.frame = CGRect(x: x, y: y, width: width, height: CGFloat(hei*2/3))
            self.tableView.frame = CGRect(x: x, y: y, width: width, height: CGFloat(hei/3))
            self.tableView.frame = CGRect(x: x, y: y, width: width, height: CGFloat(0))
        }) { (finished) in
            self.grayView.isHidden = true
        }
    }
    // MARK: -- tableView代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.text = "\(dataArr[indexPath.row]["ID_Card"]!)"
        cell?.textLabel?.textAlignment = .center
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndexPath = indexPath
        
        hideTableView()
        
        cartBtn.setTitle("\(dataArr[indexPath.row]["ID_Card"]!)", for: .normal)
    }
    // MARK: -- 请求储值卡号
    func getCartData() -> Void {
        
        showHud(in: view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_UserMoney_Car", method: .post, parameters: ["data":"{\"Buyer_id\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\"}"], success: { (results) in
            
            let json = JSON(results)
            
            if json["resultStatus"] == 1 {
                self.hideHud()
                self.dataArr = json["data"].arrayObject as! [[String : Any]]
                self.cartBtn.setTitle("\(self.dataArr[0]["ID_Card"]!)", for: .normal)
            }else{
                self.showHint(in: self.view, hint: "没有可用的储值卡,请先添加一个储值卡")
            }

            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
    }
    // MARK: -- 选择卡号
    func cartBtnAction() -> Void {
        moneyTF.resignFirstResponder()
        
        guard dataArr.count != 0 else {
            self.showHint(in: self.view, hint: "没有可用的储值卡,请先添加一个储值卡")
            return
        }
        
        self.tableView.reloadData()
        
        showTableView()
    }
    // MARK: -- 转账请求
    func doBtnAction() -> Void {
        moneyTF.resignFirstResponder()
        
        guard dataArr.count != 0 else {
            self.showHint(in: self.view, hint: "没有可用的储值卡,请先添加一个储值卡")
            return
        }
        
        guard moneyTF.text?.characters.count != 0 else {
            self.showHint(in: self.view, hint: "金额不能为空")
            return
        }
        
        let zc = ZCTradeView()
        zc.finish = { [weak self] psw in
            self?.doBtnAction1(psw: psw!)
        }
        zc.show()
        
    }
    
    func doBtnAction1(psw: String) -> Void {
        
        showHud(in: view)
        
        var url = ""
        
        if self.title == "转入" {
            url = "/Simple_online/Move_Car_money_to_wallet"
        }else{
            url = "/Simple_online/Move_Wallet_money_to_Car"
        }
        
        
        AlamofireNetWork.required(urlString: url, method: .post, parameters: ["data":"{\"Buyer_id\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\",\"ID_Card\":\"\(dataArr[currentIndexPath.row]["ID_Card"]!)\",\"money\":\"\(moneyTF.text!)\",\"PayPwd\":\"\(psw.md5String())\",\"app_system\":\"\(UIDevice.current.systemName)\"}"], success: { (results) in
            
            let json = JSON(results)
            
            var str = ""
            
            switch json["resultStatus"].string! {
            case "1":
                str = "\(self.title!)成功"
                if self.reloadPriceLabel != nil {
                    self.reloadPriceLabel!()
                }
                self.navigationController?.popViewController(animated: true)
            case "2":
                str = "余额不足"
            case "3":
                str = "卡信息有误"
            case "4":
                str = "无该收款卡号"
            case "5":
                str = "支付密码错误"
            default:
                str = "转账金额输入不正确"
            }
            
            self.showHint(in: self.view, hint: str)
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })

    }
    
    func setupUI() {
        view.addSubview(topBoxView)
        topBoxView.addSubview(cartBtn)
        topBoxView.addSubview(moneyTF)
        moneyTF.delegate = self
        
        view.addSubview(botBoxView)
        botBoxView.addSubview(doBtn)
        
        view.addSubview(grayView)
        grayView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func layoutUI() {
        
        topBoxView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.view).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(108)
        }
        
        cartBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(topBoxView).offset(5)
            make.height.equalTo(moneyTF)
            make.right.equalTo(-5)
            make.bottom.equalTo(moneyTF.snp.top).offset(-5)
        }
        
        moneyTF.snp.makeConstraints { (make) in
            make.top.equalTo(cartBtn.snp.bottom).offset(5)
            make.left.right.equalTo(cartBtn)
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
            make.height.equalTo(moneyTF.snp.height)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
