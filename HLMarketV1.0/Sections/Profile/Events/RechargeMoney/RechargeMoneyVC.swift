//
//  RechargeMoneyVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/28.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

struct RechargeMoneyOrderNO {
    let orderNo: String
    init() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMddHHmmss"
        self.orderNo = dateformatter.string(from: Date()) + "\(arc4random()%10)" + "\(arc4random()%10)" + "\(arc4random()%10)"
    }
}

fileprivate let kRechargeMoneyPriceTCellID = "kRechargeMoneyPriceTCellID"
fileprivate let kRechargeMoneyTCellID = "kRechargeMoneyTCellID"

class RechargeMoneyVC: BaseViewController {
    
    var model: RechargeStrategy?
    
    fileprivate var payStyleArr = [[String:String]]()
    
    fileprivate let orderNo = RechargeMoneyOrderNO()
    
    lazy var orderPayTableView:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 50)
        let tableView = UITableView.init(frame: rect, style: .grouped)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = BGCOLOR
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RechargeMoneyPriceTCell.self, forCellReuseIdentifier: kRechargeMoneyPriceTCellID)
        tableView.register(RechargeMoneyTCell.self, forCellReuseIdentifier: kRechargeMoneyTCellID)
        
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
        btn.isUserInteractionEnabled = false;
        return btn
    }()
    
    fileprivate var selectPayIndexPath = IndexPath(row: 0, section: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "充值"
        
        //注册微信支付结果通知
        NotificationCenter.default.addObserver(self, selector: #selector(receive_WX_State(not:)), name: NSNotification.Name(rawValue: "Payment_WX_State"), object: nil)
        
        view.addSubview(orderPayTableView)
        view.addSubview(doBtn)
        automaticallyAdjustsScrollViewInsets = false
        
        getPayStyleData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: -- tableView代理
extension RechargeMoneyVC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0 else {
            return 1
        }
        return 2
    }
    // MARK: -- cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section,indexPath.row) {
        case (0,_):
            let cell:RechargeMoneyPriceTCell = tableView.dequeueReusableCell(withIdentifier: kRechargeMoneyPriceTCellID, for: indexPath) as! RechargeMoneyPriceTCell
            cell.model = self.model
            return cell
        case (1,let row):
            let cell:RechargeMoneyTCell = tableView.dequeueReusableCell(withIdentifier: kRechargeMoneyTCellID, for: indexPath) as! RechargeMoneyTCell
            switch row {
            case 0:
                cell.payStyleLabel.text = "支付宝充值"
                cell.type = .zfb
            case 1:
                cell.payStyleLabel.text = "微信充值"
                cell.type = .wx
            default:
                break
            }
            cell.selectedState = indexPath == selectPayIndexPath
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
        
        guard selectPayIndexPath != indexPath else {
            return
        }
        
        let oldCell = orderPayTableView.cellForRow(at: selectPayIndexPath) as! RechargeMoneyTCell
        oldCell.selectedState = false
        
        selectPayIndexPath = indexPath
        
        let currentCell = orderPayTableView.cellForRow(at: indexPath) as! RechargeMoneyTCell
        currentCell.selectedState = true
        
    }
    
}

// MARK: -- 数据请求
extension RechargeMoneyVC {
    
    // MARK: -- 获取支付方式信息余额
    func getPayStyleData() -> Void {
        
        showHud(in: self.view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_Pay_Way", method: .post, parameters: nil, success: { (results) in
            
            let json = JSON(results)
            
            guard json["resultStatus"] == "1" else{
                self.showHint(in: self.view, hint: "获取支付信息出错")
                return
            }
            
            self.payStyleArr = json["dDate"].arrayObject as! [[String : String]]
            
            self.hideHud()
            self.doBtn.isUserInteractionEnabled = true
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
    }
    // MARK: -- 确认
    func doBtnAction() -> Void {
        
        switch (selectPayIndexPath.row) {
        case 0:
           alipay(dic: self.payStyleArr[0])
        case 1:
           wxpay(dic: self.payStyleArr[1])
        default:
            
            break
        }
        
    }
    
    // MARK: -- 支付宝支付
    func alipay(dic: [String:String]) -> Void {
        let privateKey = dic["Public_key"]
        
        let order = AlipayOrder()
        order.partner          = dic["Partner"]!
        order.seller           = dic["Seller"]!
        //#warning 单号的变换
        order.tradeNO          = self.orderNo.orderNo
        //订单ID（由商家自行制定）
        order.productName      = "乐家优鲜-钱包充值" //商品标题
        order.productDescription = "钱包充值" //商品描述
        order.amount  = self.model!.pay_Money!//商品价格
//        order.amount           = "0.01"//商品价格
        order.notifyURL        = DefaultURL + "/Simple_online/Pay_State"//回调URL、这个网址给你的服务器返回这个订单支付成功的消息
        order.service          = "mobile.securitypay.pay"
        order.paymentType      = "1"
        order.inputCharset     = "utf-8"
        order.itBPay           = "30m"
        order.showUrl          = "m.alipay.com"
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        let appScheme    = "WarelucentHLMarket"
        //将商品信息拼接成字符串
        let orderSpec    = order.orderStr()
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        let signer = CreateRSADataSigner(privateKey)
        let signedString = signer?.sign(orderSpec)
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        var orderString = ""
        if signedString != nil {
            orderString = orderSpec + "&sign=\"" + signedString! + "\"&sign_type=\"RSA\""
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic) in
                if resultDic?["resultStatus"] as? String  == "9000" {
                    self.walletRecharge(type: "1")
                }else {
                    self.showHint(in: self.view, hint: "支付宝支付失败(用户取消)")
                }
            })
        }
    }
    
    // MARK: -- 微信支付
    func wxpay(dic: [String:String]) -> Void {
        
        //注册
        WXApi.registerApp(dic["Partner"])
        
        let order = WxpayOrder()
        order.appid = dic["Partner"]!
        order.attach = UserStoreManager.sharedManager.getStoreName() + "-" + UserStoreManager.sharedManager.getStoreNo()
        order.body = "乐家优鲜-钱包充值"
        order.detail = "钱包充值"
        order.mch_id = dic["Seller"]!
        order.notify_url = DefaultURL + "/Simple_online/WeChat_Notice"
        order.out_trade_no = self.orderNo.orderNo
        let price:Float = (self.model!.pay_Money! as NSString).floatValue
        order.total_fee = "\(Int(CGFloat(price)*CGFloat(100)))"
//        order.total_fee = "1"
        order.key = dic["Public_key"]!
        
        let parameter = order.unifiedOrder()
        
        let url = "https://api.mch.weixin.qq.com/pay/unifiedorder"
        
        XMLNetWork.postxml(withUrl: url, dataDic: parameter) { [weak self] (state, result) in
            
            if state == false {
                self?.showHint(in: self!.view, hint: "微信支付出错")
                return
            }
            
            var dic1 = result as? [String:String]
            let retcode = dic1!["return_code"]!
            
            if retcode != "SUCCESS" {
                self?.showHint(in: self!.view, hint: "微信支付出错(\(dic1!["return_msg"]!))")
                return
            }
            
            let request = PayReq()
            request.partnerId = dic1!["mch_id"]
            request.prepayId = dic1!["prepay_id"]
            request.package = "Sign=WXPay"
            request.nonceStr = order.createWX_nonce_str()
            request.timeStamp = UInt32(order.getWX_PayReq_Date())
            request.sign = order.createWX_PayReq_Sign(request: request)
            WXApi.send(request)
        }
        
    }
    // MARK: -- 微信支付结果通知
    func receive_WX_State(not: Notification) -> Void {
        
        let dic = not.userInfo as! [String:String]
        if dic["state"] == "1" {
            
            self.walletRecharge(type: "2")
            
        }else {
            self.showHint(in: self.view, hint: "微信支付失败(用户取消)")
        }
        
    }
    // MARK: -- 钱包充值
    func walletRecharge(type: String) -> Void {
        
        showHud(in: self.view)
        
        let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo
        let price = self.model!.pay_Money!
        let encryption = userNo! + price + "warelucent"
        AlamofireNetWork.required(urlString: "/Simple_online/App_Charge_Money_Notify", method: .post, parameters: ["UserNo":userNo!, "buyer_pay_amount":price, "excess_Money": self.model!.excess_Money!, "Signature":encryption.md5String(),"cStoreNo":UserStoreManager.sharedManager.getStoreNo(),"Pay_wayId":type], success: { (result) in
            
            let json = JSON(result)
            
            guard json["resultStatus"] == "1" else {
                self.showHint(in: self.view, hint: "扣款成功,支付出错,请联系客服!")
                return
            }
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Payment_WX_State"), object: nil)
            
            self.showHint(in: self.view, hint: "充值成功")
            
            DispatchQueue_AfterExecute(delay: 1, blok: { 
                self.navigationController?.popViewController(animated: true)
            })
            
            
        }) { (error) in
            self.hideHud()
        }
        
    }
    
}
