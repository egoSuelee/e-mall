//
//  OrderPay1VC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/25.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let kOrderPay1PriceTCellID = "kOrderPay1PriceTCellID"
fileprivate let kOrderPay1StyleTCellID = "kOrderPay1StyleTCellID"

class OrderPay1VC: BaseViewController {
    
    /// 数据源(订单编号,总价,支付方式数组)
    var orderData: (orderNo: String, price: String, payWays: [[String:String]]) = ("","",[])
    
    lazy var orderPayTableView:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 50)
        let tableView = UITableView.init(frame: rect, style: .grouped)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = BGCOLOR
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OrderPay1PriceTCell.self, forCellReuseIdentifier: kOrderPay1PriceTCellID)
        tableView.register(OrderPay1StyleTCell.self, forCellReuseIdentifier: kOrderPay1StyleTCellID)
        
        return tableView
        }()
    lazy var doBtn: UIButton = {
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 0, y: kScreenH - kNavigationBarH - kStatusBarH - 50, width: kScreenW, height: 50)
        btn.setTitle("确认", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.backgroundColor = UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(doBtnAction), for: .touchUpInside)
        return btn
    }()
    
    fileprivate var walletMoney = ""
    
    fileprivate var publicKey = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "订单支付"
        
        view.addSubview(orderPayTableView)
        view.addSubview(doBtn)
        automaticallyAdjustsScrollViewInsets = false
        
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backBtn.setImage(#imageLiteral(resourceName: "差号"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        getWalletMoney()
    }
    
    func backBtnAction() -> Void {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: -- tableView代理
extension OrderPay1VC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 2:
            return 2
        default:
            return 1
        }
        
    }
    // MARK: -- cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 70
        default:
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section,indexPath.row) {
        case (0,_):
            let cell:OrderPay1PriceTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPay1PriceTCellID, for: indexPath) as! OrderPay1PriceTCell
            cell.price = self.orderData.price
            return cell
        case (1,_):
            let cell:OrderPay1StyleTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPay1StyleTCellID, for: indexPath) as! OrderPay1StyleTCell
            cell.payStyleLabel.text = "账户余额支付"
            cell.priceLabel.text = self.walletMoney
            cell.type = .wallet
            return cell
        case (2,let row):
            let cell:OrderPay1StyleTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPay1StyleTCellID, for: indexPath) as! OrderPay1StyleTCell
            switch row {
            case 0:
                cell.payStyleLabel.text = "支付宝充值"
                cell.type = .zfb
            case 1:
                cell.payStyleLabel.text = "微信充值"
                cell.type = .wx
            default:
//                cell.payStyleLabel.text = "储值卡充值"
//                cell.type = .czk
                break
            }
            return cell
        default:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            return cell
        }
    }
    // MARK: -- header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.00001
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        guard section != 0 else {
            return view
        }
        
        let  label = UILabel(frame: CGRect(x: WID, y: 0, width: kScreenW, height: 30))
        label.font = font(16)
        
        switch section {
        case 1:
            label.text = "支付方式"
        case 2:
            label.text = "余额充值"
        default:
            label.text = ""
        }
        
        view.addSubview(label)
        
        let grayView = UIView(frame: CGRect(x: 0, y: 29, width: kScreenW, height: 1));
        grayView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        view.addSubview(grayView)
        
        return view
    }
    // MARK: -- cell点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 2 else {
            return
        }
        
        switch indexPath.row {
        case 0:
            let vc = RechargeMoneyVC1()
            vc.navigationItem.title = "支付宝充值"
            vc.data = (self.orderData.orderNo,1,self.orderData.payWays[0],nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = RechargeMoneyVC1()
            vc.navigationItem.title = "微信充值"
            vc.data = (self.orderData.orderNo,2,self.orderData.payWays[1],nil)
            self.navigationController?.pushViewController(vc, animated: true)
//        case 2:
//            let vc = WalletAccountBalanceInOrOutVC()
//            vc.title = "转入"
//            vc.reloadPriceLabel = { [weak self] in
//                self?.getWalletMoney()
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
}

// MARK: -- 数据请求
extension OrderPay1VC {
    
    // MARK: -- 获取钱包余额
    func getWalletMoney() -> Void {
        
        AlamofireNetWork.required(urlString: "/Simple_online/LastMoneyquery", method: .post, parameters: ["name":"{\"id\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\"}"], success: { (results) in
            
            let json = JSON(results)
            
            self.walletMoney = String.init(format: "%0.2f元", Float(Double(json["resultStatus"].float!)))
            self.orderPayTableView.reloadSections([1], with: .fade)
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
    }
    
    // MARK: -- 确认
    func doBtnAction() -> Void {
        
        walletpay()
        
    }
    // MARK: -- 获取钱包支付公钥
    func walletpay() -> Void {
        
        showHud(in: view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/KEY", method: .get, parameters: nil, success: { (results) in
            
            self.hideHud()
            
            let json = JSON(results)
            
            self.publicKey = json["resultStatus"].string!
            
            let zc = ZCTradeView()
            zc.finish = { [weak self] psw in
                self?.walletpay1(psw: psw!)
            }
            zc.show()
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
        
    }
    // MARK: -- 钱包支付
    func walletpay1(psw: String) -> Void {
        
        let handler = HBRSAHandler()
        handler.importKey(with: KeyTypePrivate, andPath: private_key_string)
        handler.importKey(with: KeyTypePublic, andPath: public_key_string)
        
        let str = "{\"Paypass\":\"\(psw.md5String())\",\"WServerID_cStore\":\"1\",\"WServerID_buyer\":\"1\",\"cStoreNo\":\"\(UserStoreManager.sharedManager.getStoreNo())\",\"notify_url\":\"http://192.168.3.153:5080/WalletNotify\",\"fLastMoney\":\"\(self.orderData.price)\",\"Buyer_id\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\",\"cardno\":\"\",\"cSaleSheetNo\":\"\(self.orderData.orderNo)\"}"
        
        let sign = RSAObject.encryptString(str, publicKey: publicKey)
        
        let parameter = ["name":"{\"device\":\"\(UIDevice.current.systemName)\",\"PublicKey\":\"\(public_key_string)\",\"sign\":\"\(sign!)\",\"signgg\":\"\(handler.signMD5String(sign!))\"}"]
        
        AlamofireNetWork.required(urlString: "/Simple_online/WallPay", method: .post, parameters: parameter, success: { (results) in
            
            let json = JSON(results)
            
            var str = "支付失败"
            switch json["resultStatus"] {
            case -1:
                str="支付密码错误"
            case 0:
                str="支付失败"
            case 1:
                str="支付成功"
            case 2:
                str="余额不足"
            case 3:
                str="用户信息有误"
            case 4:
                str="店铺信息有误"
            case -6:
                str="订单已支付"
            default:
                break;
                
            }
            
            self.showHint(in: self.view, hint: str)
            
            if str == "支付成功" {
                self.updateOrderState(type: "3")
            }
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
        
    }
    // MARK: -- 向服务器发送支付完成通知
    func updateOrderState(type: String) -> Void {
        
        let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo
        let encryption = self.orderData.orderNo + userNo! + self.orderData.price + "warelucent"
        AlamofireNetWork.required(urlString: "/Simple_online/App_Pay_Notify", method: .post, parameters: ["UserNo":userNo!, "out_trade_no":self.orderData.orderNo, "buyer_pay_amount":self.orderData.price, "Signature":encryption.md5String(),"cStoreNo":UserStoreManager.sharedManager.getStoreNo(),"Pay_wayId":type], success: { (result) in
            
            let vc = OrderPaySuccessVC()
            vc.orderPrice = self.orderData.price
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }) { (error) in
            self.hideHud()
        }
    }
    
}

// MARK: -- 禁用/开启边缘右滑
extension OrderPay1VC {
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
}
