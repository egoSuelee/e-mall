//
//  RechargeMoneyVC1.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/8/3.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class RechargeMoneyVC1: BaseViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var cartTableView: UICollectionView!
    
    @IBOutlet weak var rechargeBtn: UIButton!
    
    var data: (orderNo: String, payStyleType: Int , payStyleData: [String:String], model: RechargeStrategy?) = ("",0,[:],nil)
    
    fileprivate var modelArr = [RechargeStrategy]()
    
    fileprivate var currentIndexRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册微信支付结果通知
        NotificationCenter.default.addObserver(self, selector: #selector(receive_WX_State(not:)), name: NSNotification.Name(rawValue: "Payment_WX_State"), object: nil)
        
        if let userIcon = UserAuthManager.sharedManager.getUserModel()?.UserIcon {
            userImageView.kf.setImage(with: URL.init(string: DefaultURL + "/Simple_online/" + userIcon) as Resource?, placeholder: UIImage.init(named: "头像"),options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(1)), KingfisherOptionsInfoItem.forceRefresh], progressBlock: nil, completionHandler: nil)
        } else {
            userImageView.image = UIImage.init(named: "头像")
        }
        userImageView.layer.cornerRadius = 30
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
        let model = UserAuthManager.sharedManager.getUserModel()
        if model?.UserNo == "" {
            userNameLabel.text = "暂无昵称"
        } else {
            userNameLabel.text = model!.UserNo
        }
        
        rechargeBtn.layer.borderColor = UIColor.appMainColor().cgColor
        rechargeBtn.layer.borderWidth = 1
        rechargeBtn.layer.cornerRadius = 22
        
        let layout = CDFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.sectionInset = UIEdgeInsetsMake(0, LAYOUT_LEFTORRIGHT_WIDTH, 0, LAYOUT_LEFTORRIGHT_WIDTH)
        layout.itemSize = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
        
        cartTableView.collectionViewLayout = layout
        cartTableView.backgroundColor = UIColor.clear
        cartTableView.showsHorizontalScrollIndicator = false
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(CDViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CDViewCell.self))
        
        requestForRechargeStrategy()
    }
    

    @IBAction func rechargeBtnAction(_ sender: Any) {
        
        guard self.modelArr.count != 0 else {
            return
        }
        
        self.data.model = self.modelArr[currentIndexRow]
        
        switch self.data.payStyleType {
        case 1:
            alipay(dic: self.data.payStyleData)
        case 2:
            wxpay(dic: self.data.payStyleData)
        default:
            break
        }
    }
    
    func requestForRechargeStrategy() {
        AlamofireNetWork.required(urlString: "/Simple_online/Wallet_recharge_strategy", method: .post, parameters: ["cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                let arr =  json["dDate"].arrayObject
                var tmpArr = [RechargeStrategy]()
                for dic in arr! {
                    let dic = dic as! [String:String]
                    let model = RechargeStrategy()
                    model.excess_Money = dic["excess_Money"]
                    model.pay_Money = dic["Pay_Money"]
                    tmpArr.append(model)
                }
                self.modelArr = tmpArr
                self.cartTableView.reloadData()
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RechargeMoneyVC1 : UICollectionViewDelegate , UICollectionViewDataSource{
    //UICollectionView代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cartTableView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CDViewCell.self), for: indexPath) as! CDViewCell
        let model = self.modelArr[indexPath.row]
        cell.titleLabel.text = "冲 \(model.pay_Money!)元 送 \(model.excess_Money!)元"
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //center是collectionView的frame的中心点 pInView是中心点对应到collectionVIew的contentView的坐标
        let pInView = self.view.convert(self.cartTableView.center, to: self.cartTableView)
        let indexPathNow = self.cartTableView.indexPathForItem(at: pInView)!
        self.currentIndexRow = indexPathNow.row
    }
    
}

extension RechargeMoneyVC1 {
    // MARK: -- 支付宝支付
    func alipay(dic: [String:String]) -> Void {
        let privateKey = dic["Public_key"]
        
        let order = AlipayOrder()
        order.partner          = dic["Partner"]!
        order.seller           = dic["Seller"]!
        //#warning 单号的变换
        order.tradeNO          = self.data.orderNo
        //订单ID（由商家自行制定）
        order.productName      = "乐家优鲜-钱包充值" //商品标题
        order.productDescription = "钱包充值" //商品描述
        order.amount  = self.data.model!.pay_Money!//商品价格
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
        order.out_trade_no = self.data.orderNo
        let price:Float = (self.data.model!.pay_Money! as NSString).floatValue
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
        let price = self.data.model!.pay_Money!
        let encryption = userNo! + price + "warelucent"
        AlamofireNetWork.required(urlString: "/Simple_online/App_Charge_Money_Notify", method: .post, parameters: ["UserNo":userNo!, "buyer_pay_amount":price, "excess_Money": self.data.model!.excess_Money!, "Signature":encryption.md5String(),"cStoreNo":UserStoreManager.sharedManager.getStoreNo(),"Pay_wayId":type], success: { (result) in
            
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
