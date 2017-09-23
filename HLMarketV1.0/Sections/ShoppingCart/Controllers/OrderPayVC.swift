//
//  OrderPayVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 12/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let kOrderPayGoodsInfoCellID = "kOrderPayGoodsInfoCellID"
fileprivate let kOrderPayStyleCellID = "kOrderPayStyleCellID"
fileprivate let kOrderPayShopCellID = "kOrderPayShopCellID"
fileprivate let kOrderPayShopOrTimeCellID = "kOrderPayShopOrTimeCellID"
fileprivate let kOrderPayDetailCellID = "kOrderPayDetailCellID"
fileprivate let kOrderPayRemarkCellID = "kOrderPayRemarkCellID"
fileprivate let kOrderPayAdressCellID = "kOrderPayAdressCellID"

struct SendTime {
    var time: String {
        get{
            return getTime()
        }
    }
    var time1: String
    var time2: String
    init(time1:String, time2:String) {
        self.time1 = time1
        self.time2 = time2
    }
    
    fileprivate func getTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH"
        
        let dateformatter1 = DateFormatter()
        dateformatter1.dateFormat = "yyyy-MM-dd"
        
        let hours = Int(dateformatter.string(from: Date()))
        
        if let hour = hours, hour >= 17 {
            return dateformatter1.string(from: Date.init(timeInterval: 24*60*60, since: Date()))
        }else{
            return dateformatter1.string(from: Date())
        }
    }
    
    func getTime1Str() -> String {
        return self.time + " " + self.time1 + ":00"
    }
    func getTime2Str() -> String {
        return self.time + " " + self.time2 + ":00"
    }
    
}

class OrderPayVC: BaseViewController {
    
    /// 数据源(订单编号,支付方式数组,商品总价,配送费,优惠金额,是否首单,服务门店,地址)
    var orderData: (orderNo: String, goodsData: [[String:String]], payWays: [[String:String]], totalMoney: Float, freightCost: Float, discount: Float, isFirstOrder: String, shop: StoreModel?, address: AddressUserModel?) = ("",[],[],0,0,0,"0",nil,nil)
    //时间段
    var sendTime = SendTime(time1: "09:00", time2: "09:30")
    
    //当前配送方式
    var currentSendWaysIndex = 0 {
        didSet {
            var string: String = ""
            if self.orderData.isFirstOrder == "1" {
                string = "合计:  ￥" + "\((self.orderData.totalMoney * 0.9) + (self.currentSendWaysIndex == 0 ? 0 : self.orderData.freightCost) - (self.orderData.discount))".cgFloatString()
            }else {
                string = "合计:  ￥" + "\((self.orderData.totalMoney) + (self.currentSendWaysIndex == 0 ? 0 : self.orderData.freightCost) - (self.orderData.discount))".cgFloatString()
            }
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: string)
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17),range: NSMakeRange(0,3))
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20),range: NSMakeRange(3,string.characters.count-3))
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1),range: NSMakeRange(3, string.characters.count-3))
            self.sumLabel?.attributedText = attributeString
        }
    }
    
    //MARK: --- Label
    var sumLabel:UILabel?
    
    fileprivate var publicKey = ""
    
    fileprivate var _offset:CGFloat = 0.0
    
    lazy var orderPayTableView:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 50)
        let tableView = UITableView.init(frame: rect, style: .grouped)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = BGCOLOR
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OrderPayGoodsInfoCell.self, forCellReuseIdentifier: kOrderPayGoodsInfoCellID)
        tableView.register(OrderPayStyleTCell.self, forCellReuseIdentifier: kOrderPayStyleCellID)
        tableView.register(OrderPayShopTCell.self, forCellReuseIdentifier: kOrderPayShopCellID)
        tableView.register(OrderPayShopOrTimeTCell.self, forCellReuseIdentifier: kOrderPayShopOrTimeCellID)
        tableView.register(OrderPayDetailTCell.self, forCellReuseIdentifier: kOrderPayDetailCellID)
        tableView.register(OrderPayRemarkTCell.self, forCellReuseIdentifier: kOrderPayRemarkCellID)
        tableView.register(OrderPayAdressCell.self, forCellReuseIdentifier: kOrderPayAdressCellID)
        
        return tableView
        }()
    lazy var commitView:UIView = { [weak self] in
        let view = UIView.init(frame:CGRect(x:0, y:kScreenH - kNavigationBarH - kStatusBarH - 50, width: kScreenW, height:50 ))
        
        view.backgroundColor = UIColor.white
        
        let label = UILabel.init()
        label.textAlignment = .center
        var string: String = ""
        if self?.orderData.isFirstOrder == "1" {
            string = "合计:  ￥" + "\((self!.orderData.totalMoney * 0.9) + (self!.currentSendWaysIndex == 0 ? 0 : self!.orderData.freightCost) - (self!.orderData.discount))".cgFloatString()
        }else {
            string = "合计:  ￥" + "\((self!.orderData.totalMoney) + (self!.currentSendWaysIndex == 0 ? 0 : self!.orderData.freightCost) - (self!.orderData.discount))".cgFloatString()
        }
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: string)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17),range: NSMakeRange(0,3))
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20),range: NSMakeRange(3,string.characters.count-3))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1),range: NSMakeRange(3, string.characters.count-3))
        label.attributedText = attributeString
        
        
        self?.sumLabel = label
        
        var btnTitle = "确认"
        let btn = UIButton.init(type: .system)
        btn.setTitle(btnTitle, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.backgroundColor = UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(commitOrderAction), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(btn)
        
        btn.snp.makeConstraints({ (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview()
        })
        label.snp.makeConstraints({ (make) in
            make.right.equalTo(btn.snp.left)
            make.centerY.equalTo(btn)
            make.left.equalToSuperview()
            make.height.equalToSuperview()
        })
        return view
    }()
    var pickerView: OrderPayDatePicker?
    
    // MARK: -- 提交订单
    func commitOrderAction() {
        
        guard self.orderData.shop != nil else {
            showHint(in: self.view, hint: "请先选择门店")
            return
        }
        
        if self.currentSendWaysIndex == 1 {
            guard self.orderData.address != nil else {
                showHint(in: self.view, hint: "请先选择收货地址")
                return
            }
        }
        
        //self.orderData.orderNo == ""  表示从购物车跳转,否则为未付款订单跳转
        guard self.orderData.orderNo == "" else {
            return
        }
        
        guard (UserAuthManager.sharedManager.getUserModel()?.UserNo) != nil else {
            showHint(in: self.view, hint: "请先登录")
            return
        }
        
        let json = JSON(self.orderData.goodsData)
        let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo
        self.showHud(in: self.view)
        // MARK: -- Cover_Fresh 检测商品是否是生鲜(还未修改)
        AlamofireNetWork.required(urlString: "/Simple_online/Upload_order", method: .post, parameters: ["UserNo":userNo!, "AddressID": currentSendWaysIndex == 0 ? self.orderData.shop!.id : self.orderData.address!.AddressID, "Notes":"", "dData":"\(json)", "Freight":"\(self.currentSendWaysIndex == 0 ? 0 : self.orderData.freightCost)".cgFloatString(),"cStoreNo":UserStoreManager.sharedManager.getStoreNo(), "Send_Way": currentSendWaysIndex == 0 ? "1" : "2","Cover_Fresh":"1","Start_time":self.sendTime.getTime1Str(),"End_time":self.sendTime.getTime2Str(),"Send_cStoreNo":self.orderData.shop!.cStoreNo], success: { (result) in
            
            let json = JSON(result)
            
            guard json["resultStatus"] == "1" else {
                self.showHint(in: self.view, hint: "下单出错")
                return
            }
            
            //MARK: --- 发送通知告诉购物车
            NotificationCenter.default.post(name: NotiNameOfCommitOrder, object: self, userInfo: [:])
            
            self.orderData.orderNo = json["dDate"].string!
            
            let vc = OrderPay1VC()
            
            if self.orderData.isFirstOrder == "1" {
                vc.orderData = (self.orderData.orderNo,"\(self.orderData.totalMoney * 0.9 + (self.currentSendWaysIndex == 0 ? 0 : self.orderData.freightCost)-self.orderData.discount)".cgFloatString(),self.orderData.payWays)
            }else {
                vc.orderData = (self.orderData.orderNo,"\(self.orderData.totalMoney+(self.currentSendWaysIndex == 0 ? 0 : self.orderData.freightCost)-self.orderData.discount)".cgFloatString(),self.orderData.payWays)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }) { (error) in
            self.hideHud()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "订单确认"
        
        view.addSubview(orderPayTableView)
        view.addSubview(commitView)
        self.pickerView = OrderPayDatePicker(target: self.view, frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-64))
        view.addSubview(self.pickerView!)
        automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: -- tableView代理
extension OrderPayVC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentSendWaysIndex == 0 ? 6 : 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var section1 = section
        
        if currentSendWaysIndex == 0 && section1 > 1 {
            section1 += 1
        }
        
        switch section1 {
        case 1:
            return 2
        case 4:
            return self.orderData.goodsData.count
        default:
            return 1
        }
        
    }
    // MARK: -- cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var section = indexPath.section
        
        if currentSendWaysIndex == 0 && section > 1 {
            section += 1
        }
        
        switch section {
        case 0:
            return 80
        case 2:
            return 100
        case 4:
            return 70
        case 6:
            return 90
        default:
            return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var index = (indexPath.section,indexPath.row)
    
        if currentSendWaysIndex == 0 && index.0 > 1 {
            index.0 += 1
        }
        
        switch index {
        case (0,_):
            let cell:OrderPayShopTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPayShopCellID, for: indexPath) as! OrderPayShopTCell
            cell.storeModel = self.orderData.shop
            return cell
        case let (1,row):
            let cell:OrderPayStyleTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPayStyleCellID, for: indexPath) as! OrderPayStyleTCell
            cell.selectedState = indexPath.row == currentSendWaysIndex
            switch row {
            case 0:
                cell.payStyleLabel.text = "自提"
            case 1:
                cell.payStyleLabel.text = "送货上门"
            default:
                cell.payStyleLabel.text = ""
            }
            return cell
        case (2,_):
            let cell:OrderPayAdressCell = tableView.dequeueReusableCell(withIdentifier: kOrderPayAdressCellID, for: indexPath) as! OrderPayAdressCell
            cell.model = self.orderData.address
            return cell
        case (3,_):
            let cell:OrderPayShopOrTimeTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPayShopOrTimeCellID, for: indexPath) as! OrderPayShopOrTimeTCell
            cell.timeData = self.sendTime
            return cell
        case (4,_):
            let cell:OrderPayGoodsInfoCell = tableView.dequeueReusableCell(withIdentifier: kOrderPayGoodsInfoCellID, for: indexPath) as! OrderPayGoodsInfoCell
            
            let servermodel = self.orderData.goodsData[indexPath.row]
            
            let model = GoodsControlModel.init(dict: ["avtarImage":servermodel["cGoodsImagePath"] ?? "","price":servermodel["Last_Price"] ?? "", "title":servermodel["cGoodsName"] ?? "", "count":servermodel["Num"] ?? ""])
            cell.goodsControlView.model = model
            cell.selectionStyle = .none
            return cell
        case (5,_):
            let cell:OrderPayRemarkTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPayRemarkCellID, for: indexPath) as! OrderPayRemarkTCell
            cell.textField.delegate = self
            return cell
        case (6,_):
            let cell:OrderPayDetailTCell = tableView.dequeueReusableCell(withIdentifier: kOrderPayDetailCellID, for: indexPath) as! OrderPayDetailTCell
            
            if self.orderData.isFirstOrder == "1" {
                cell.dataDic = ["total":"\(self.orderData.totalMoney)".cgFloatString(),"freight":"+"+"\(self.currentSendWaysIndex == 0 ? 0 : self.orderData.freightCost)".cgFloatString(),"discount":"-" + "\(self.orderData.totalMoney * 0.1)".cgFloatString() + "(首单优惠)"]
            }else{
                cell.dataDic = ["total":"\(self.orderData.totalMoney)".cgFloatString(),"freight":"+"+"\(self.currentSendWaysIndex == 0 ? 0 : self.orderData.freightCost)".cgFloatString(),"discount":"-0.00"]
            }
            
            return cell
        default:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            return cell
        }
    }
    // MARK: -- header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let  label = UILabel(frame: CGRect(x: WID/2, y: 0, width: kScreenW, height: 30))
        label.font = font(16)
        
        var section1 = section
        
        if currentSendWaysIndex == 0 && section1 > 1 {
            section1 += 1
        }
        
        switch section1 {
        case 0:
            label.text = "选择服务门店"
        case 1:
            label.text = "选择配送方式"
        case 2:
            label.text = "配送地址"
        case 3:
            label.text = "选择配送时间段"
        case 4:
            label.text = "订单商品详情"
        case 5:
            label.text = "备注"
        case 6:
            label.text = "支付详情"
        default:
            label.text = ""
        }
        
        view.addSubview(label)
        
        let grayView = UIView(frame: CGRect(x: 0, y: 29, width: kScreenW, height: 1));
        grayView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        view.addSubview(grayView)
        
        return view
    }
    // MARK: -- footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.gray.withAlphaComponent(0.07)
        return footerView
    }
    // MARK: -- cell点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var index = (indexPath.section,indexPath.row)
        
        if currentSendWaysIndex == 0 && index.0 > 1 {
            index.0 += 1
        }
        
        switch index {
//        case (0,_):
//            let vc = ChooseStoreVC()
//            vc.type = 1
//            vc.itemDidSelectClick = {[weak self] (store)->Void in
//                if store.cStoreNo == self?.orderData.shop?.cStoreNo {
//                    return
//                } else {
//                    self?.orderData.shop = store
//                    self?.orderPayTableView.reloadSections([0], with: .fade)
//                    self?.updateUserAdressAfterChangeStore(store: store)
//                }
//            }
//            _ = self.navigationController?.pushViewController(vc, animated: true)
        case let (1,row):
            
            guard currentSendWaysIndex != row else {
                return
            }

            currentSendWaysIndex = row
            
            tableView.reloadData()
            
        case (2,_):
            let vc = ChooseAddressVC()
            vc.navigationItem.title = "选择收货地址"
            vc.serviceStoreNo = self.orderData.shop?.cStoreNo
            vc.chooseCallBack = {(model:AddressUserModel) in
                self.orderData.address = model
                self.orderPayTableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case (3,_):
            self.pickerView?.datePickerBlock = { [unowned self] (tag,time1,time2) in
                
                guard tag else {
                    self.showHint(in: self.view, hint: "时间区间选择不正确")
                    return
                }
                
                self.sendTime.time1 = time1
                self.sendTime.time2 = time2
                self.orderPayTableView.reloadSections([indexPath.section], with: .fade)
            }
             self.pickerView?.showDatePickerWithStartTime()
        default:
            break
        }

    }
    
    //Mark: --- 改变服务门店之后, 修改配送地址, 如何用户不存在可选的服务地址,返回nil
    func updateUserAdressAfterChangeStore(store:StoreModel) {
        showHud(in:view)
        var tmpAddressModelArr = [AddressUserModel]()
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            AlamofireNetWork.required(urlString: "/Simple_online/Select_User_Address", method: .post, parameters: ["UserNo":userNo,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (results) in
                let json = JSON(results)
                
                if json["resultStatus"] == "1" {
                    let dictArray = json["dDate"].arrayObject
                    for aDict in dictArray! {
                        let aDict:[String:Any] = aDict as! [String : Any]
                        let model = AddressUserModel.init(dict: aDict)
                        tmpAddressModelArr.append(model)
                    }
                    for addressModel in tmpAddressModelArr {
                        if addressModel.cStoreNo == self.orderData.shop?.cStoreNo {
                            self.orderData.address = addressModel
                            break
                        } else {
                            self.orderData.address = nil
                        }
                    }
                    DispatchQueue.main.async(execute: { 
                        self.orderPayTableView.reloadSections([2], with: .fade)
                        self.hideHud()
                    })
                    
                } else {
                    self.hideHud()
                }
            }) { (error) in
                self.showHint(in: self.view, hint: "网络请求出错")
                NSLog(error.localizedDescription)
            }
        } else {
            showHint(in: view, hint: "请先登录")
        }
        
        
    }
    

}

extension OrderPayVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: -- 开始编辑时 是自身位置上移
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let set = self.view.HL_height - (self.view.frame.origin.y + self.view.frame.size.height+90)
        
        if set < 0.0 {
            _offset = set
            
            UIView.animate(withDuration: 0.3, animations: {
                var frame = self.view.frame
                frame.origin.y = self._offset
                self.view.frame = frame
            })
        }else if set > 0.0 {
            comeBackViewFrame()
        }
        return true
    }

    // MARK: -- 检测第三方输入法 如搜狗 点击⬇️时 使自身位置复原
    func keyboardWillHide(notification: NSNotification) -> Void {
        if self.view.frame.origin.y == _offset {
            comeBackViewFrame()
        }
    }
    // MARK: -- 复原位置
    func comeBackViewFrame() -> Void {
        UIView.animate(withDuration: 0.1) {
            var frame = self.view.frame
            frame.origin.y = 64
            self.view.frame = frame
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
}
