//
//  PF_AllOrdersVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/8/4.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

fileprivate let baseTextSize = kHOrderGoodsCellHeight/10
fileprivate let scaleRate:CGFloat = 0.5

struct PFOrderMix {
    var type:PFOrderType
    var state:PFOrderState
    func isEqual(orderMix:PFOrderMix) -> Bool {
        if self.type == orderMix.type && self.state == orderMix.state {
            return true
        } else {
            return false
        }
    }
    func getParameters() -> (fage: String, Send_Way: String) {
        var parame = (fage:"",Send_Way:"")
        switch self.state.rawValue {
        case 0:
            parame.fage = "0"
        case 1,2:
            parame.fage = "1"
        case 3,4:
            parame.fage = "2"
        case 5:
            parame.fage = "3"
        default:
            break
        }
        switch self.type {
        case .PickUp:
            parame.Send_Way = "1"
        case .Dispatch:
            parame.Send_Way = "2"
        }
        return parame
    }
}

enum  PFOrderType {
    case PickUp
    case Dispatch
}

enum  PFOrderState: Int {
    case unpay = 0
    case unbeihuo
    case unpost
    case untake
    case unreceive
    case completed
}

class PF_AllOrdersVC: BaseViewController {

    var orderMix:PFOrderMix? {
        didSet {
            guard let orderMix = orderMix else {
                return
            }
            
            if oldValue == nil {
                
                switch orderMix.type {
                case .PickUp:
                    titleView.selectedSegmentIndex = 0
                    pageTitleView.reloadTitles(titleArray: ["待付款", "待备货", "待取货", "已完成"])
                case .Dispatch:
                    titleView.selectedSegmentIndex = 1
                    pageTitleView.reloadTitles(titleArray: ["待付款", "待发货", "待收货", "已完成"])
                }
                
                switch orderMix.state.rawValue {
                case 0:
                    pageTitleView.reloadTitlesColor(current: 0)
                case 1,2:
                    pageTitleView.reloadTitlesColor(current: 1)
                case 3,4:
                    pageTitleView.reloadTitlesColor(current: 2)
                case 5:
                    pageTitleView.reloadTitlesColor(current: 3)
                default:
                    break
                }
                
            }
            
            getOrderData()
        }
    }
    
    lazy var titleView:UISegmentedControl = {[weak self] in
        let rect = CGRect.init(x: 0, y: 0, width: 4*WID, height: 30)
        let titleView = UISegmentedControl.init(items: ["自提订单", "送货上门"])
        titleView.frame = rect
        titleView.tintColor = UIColor.appTextMainColor()
        titleView.setTitleTextAttributes({[NSForegroundColorAttributeName: UIColor.black]}(), for: .normal)
        titleView.addTarget(self, action: #selector(didSelectNewOrderType(sender:)), for: .valueChanged)
        return titleView
    }()
    
    func didSelectNewOrderType(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.orderMix = PFOrderMix.init(type: .PickUp, state: .unpay)
            pageTitleView.reloadTitles(titleArray: ["待付款", "待备货", "待取货", "已完成"])
            pageTitleView.reloadTitlesColor(current: 0)
        default:
            self.orderMix = PFOrderMix.init(type: .Dispatch, state: .unpay)
            pageTitleView.reloadTitles(titleArray: ["待付款", "待发货", "待收货", "已完成"])
            pageTitleView.reloadTitlesColor(current: 0)
        }
    }
    
    
    lazy var pageTitleView:PageTitleView = { () -> PageTitleView in
        let pageTitleRect = CGRect(x: 0, y: 0, width: kScreenW, height: 46)
        let pageTitleView = PageTitleView.init(frame: pageTitleRect, titles: ["待付款", "待备货", "待取货", "已完成"])
        return pageTitleView
    }()
    
    
    var dataSource:[OrderSheetServerModel]? = []
    
    var isLoad = false
    
    var currentPage = 1
    
    lazy var orderList:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 46, width: kScreenW, height: kScreenH - 64 - 50)
        let tableView = UITableView.init(frame: rect, style: .grouped)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.colorFromHex(0xf7f7fc)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PF_OrderCell.self, forCellReuseIdentifier: "kOrderSheetCELLID")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        self.navigationItem.titleView = titleView
        self.view.addSubview(pageTitleView)
        self.view.addSubview(orderList)
        pageTitleView.delegate = self
    }
    
    func getOrderData(type: String = "reload", page: Int = 1) {
        
        if type == "reload" {
            self.dataSource = []
            self.orderList.reloadData()
            self.currentPage = 1
            self.isLoad = false
        }
        
        let parame = self.orderMix!.getParameters()
        
        self.showHud(in: self.view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/PF_Select_Order", method: .post, parameters: ["UserNo":UserAuthManager.sharedManager.getUserModel()!.UserNo, "fage":parame.fage, "Number_of_pages":"\(page)","cStoreNo":UserStoreManager.sharedManager.getStoreNo(), "Send_Way":parame.Send_Way], success: { (results) in
            let json = JSON(results)
            
            self.hideHud()
            
            if json["resultStatus"] == "1" {
                
                let dictArr = json["array"].arrayObject
                if dictArr?.count == 0 {
                    return
                }
                for aDict in dictArr! {
                    let aDict:[String:Any] = aDict as! [String : Any]
                    let sheetModel = OrderSheetServerModel.init(dict: aDict)
                    self.dataSource?.append(sheetModel)
                }
                
                self.orderList.reloadData()
                
                self.isLoad = true
            }else{
                if type == "loadMore" {
                    self.isLoad = false
                    self.currentPage -= 1
                }
            }
            
        }) { (error) in
            self.showHint(in: self.view, hint: " 请求失败")
            if type == "loadMore" {
                self.isLoad = false
                self.currentPage -= 1
            }
        }
    }
}

extension PF_AllOrdersVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (dataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let deitailsArr = self.dataSource?[section]
        if let arr = deitailsArr {
            return arr.detailsModels.count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kOrderSheetCELLID") as! PF_OrderCell
        let model = self.dataSource?[indexPath.section].detailsModels[indexPath.row]
        
        let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
        cell.goodsImageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + model!.cGoodsImagePath), placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
        cell.goodsImageView.contentMode = .scaleAspectFill
        cell.goodsImageView.clipsToBounds = true
        cell.goodsNameLabel.text = model?.cGoodsName
        cell.goodsSpecLabel.text = "规格 " + model!.cSpec + "/" + model!.cUnit
        cell.priceLabel.text = "单价 ￥"+model!.Last_Price.cgFloatString()
        var _string:String = ""
        let titleLen = 1
        switch self.orderMix!.state.rawValue {
        case 3,4,5:
            cell.countLabel.text = "订单数量:x" + model!.Num.cgFloatString() + "   实际配送:x" + model!.RealityNum.cgFloatString()
            _string = "￥"+model!.Reality_Money.cgFloatString()
            //cell.totalMoneyLabel.text = "￥"+model!.Reality_Money.cgFloatString()
        default:
            _string = "￥"+model!.Last_Money.cgFloatString()
            cell.countLabel.text = "订单数量 x" + model!.Num.cgFloatString()
        }
        
        //让价格显示的更加突出一些
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: _string)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: baseTextSize*2.5*scaleRate),range: NSMakeRange(0,titleLen))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHex(0xF02B2B),range: NSMakeRange(0,titleLen))
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: baseTextSize*3*scaleRate),range: NSMakeRange(titleLen,_string.characters.count-titleLen))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHex(0xF02B2B),range: NSMakeRange(titleLen,_string.characters.count-titleLen))
        
        cell.totalMoneyLabel.attributedText = attributeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHOrderGoodsCellHeight
    }

    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = self.dataSource?[section]
        let view = UILabel.init()
        view.backgroundColor = UIColor.white
        view.text = "    订单号: " + model!.cSheetno
        view.textColor = UIColor.colorFromHex(0x282828)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kHOrderGoodsCellHeight + 12
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = self.dataSource?[section]
        let footer = PF_OrderFooterView.init(frame: .zero, state: self.orderMix!.state)
        
        let attributedStr : NSMutableAttributedString = NSMutableAttributedString()
        let str : NSAttributedString = NSAttributedString(string: "运费:" + model!.Send_Money.cgFloatString() + "元   总计:", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: baseTextSize*2.7*scaleRate),NSForegroundColorAttributeName:UIColor.colorFromHex(0x585858)])
        let str1 : NSAttributedString = NSAttributedString(string: "￥", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: baseTextSize*2.7*scaleRate),NSForegroundColorAttributeName:UIColor.colorFromHex(0xF02B2B)])
        let str2 : NSAttributedString = NSAttributedString(string: model!.Reality_All_Money.cgFloatString(), attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: baseTextSize*3.5*scaleRate),NSForegroundColorAttributeName:UIColor.colorFromHex(0xF02B2B)])
        attributedStr.append(str)
        attributedStr.append(str1)
        attributedStr.append(str2)
        
        if self.orderMix!.state.rawValue == 0 && model!.Reality_All_Money.cgFloatString() < model!.All_Money.cgFloatString()  {
            let str3 : NSAttributedString = NSAttributedString(string: "(首单9折)", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: baseTextSize*2.7*scaleRate),NSForegroundColorAttributeName:UIColor.colorFromHex(0xF02B2B)])
            attributedStr.append(str3)
        }
        
        footer.tongjiLabel.attributedText = attributedStr
        footer.section = section
        footer.delegate = self
        return footer
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if  orderList.cellForRow(at: IndexPath(row: dataSource!.count - 3, section: 0)) != nil && self.isLoad {
            self.isLoad = false
            currentPage += 1
            getOrderData(type: "loadMore", page: currentPage)
        }
        
    }
}


extension PF_AllOrdersVC:PageTitleViewDelegate {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int) {
        switch (self.orderMix!.type,index) {
        case (_,0):
            self.orderMix?.state = PFOrderState(rawValue: 0)!
        case (.PickUp,1):
            self.orderMix?.state = PFOrderState(rawValue: 1)!
        case (.Dispatch,1):
            self.orderMix?.state = PFOrderState(rawValue: 2)!
        case (.PickUp,2):
            self.orderMix?.state = PFOrderState(rawValue: 3)!
        case (.Dispatch,2):
            self.orderMix?.state = PFOrderState(rawValue: 4)!
        case (_,3):
            self.orderMix?.state = PFOrderState(rawValue: 5)!
        default:
            break
        }
    }
}

extension PF_AllOrdersVC:PF_OrderFooterViewDelegate {
    func pf_orderFooterBtnDidClick(index: Int, section: Int?) {
        guard let section = section else {
            return
        }
        
        let model = self.dataSource![section]
        
        switch (self.orderMix!.state.rawValue,index) {
        case (0,1),(1,3),(2,3),(3,2),(4,2),(5,3):
            self.connectBtnAction(model: model)
        case (0,2):
            self.cancelSheetAction(model: model, section: section)
        case (0,3):
            self.payBtnAction(model: model)
        case (3,3),(4,3):
            self.confirmBtnAction(model: model, section: section)
        default:
            break
        }
    }
}

// MARK: -- 按钮响应事件
extension PF_AllOrdersVC {
    
    //确认收货
    func confirmBtnAction(model:OrderSheetServerModel,section: Int) {
        
        let alertVC = UIAlertController.init(title: "是否确认收货?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            
            self.showHud(in: self.view)
            
            AlamofireNetWork.required(urlString: "/Simple_online/Affirm_Receipt_Goods", method: .post, parameters: ["cSheetno":model.cSheetno, "UserNo":UserAuthManager.sharedManager.getUserModel()!.UserNo, "cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: {[weak self] (result) in
                let json = JSON(result)
                if json["resultStatus"] == "1" {
                    //1. 从本地数据源中移除
                    self?.dataSource?.remove(at: section)
                    //2. 视图移除
                    self?.orderList.deleteSections([section], with: UITableViewRowAnimation.left)
                    self?.showHint(in: (self?.view)!, hint: "已确认收货")
                }else {
                    self?.showHint(in: (self?.view)!, hint: "确认收货失败")
                }
                
            }) { (error) in
                self.showHint(in: self.view, hint: "确认收货失败")
            }

        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    // MARK: -- 取消订单
    func cancelSheetAction(model:OrderSheetServerModel,section: Int) {
        
        self.showHud(in: self.view)
        //3. 网络请求移除
        AlamofireNetWork.required(urlString: "/Simple_online/Cancel_User_Order", method: .post, parameters: ["cSheetno":model.cSheetno,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { [weak self](result) in
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                //1. 从本地数据源中移除
                self?.dataSource?.remove(at: section)
                //2. 视图移除
                self?.orderList.deleteSections([section], with: UITableViewRowAnimation.left)
                self?.showHint(in: (self?.view)!, hint: "取消订单成功")
            }else{
                self?.showHint(in: (self?.view)!, hint: "取消订单失败")
            }
            
        }) {[weak self] (error) in
            self?.showHint(in: (self?.view)!, hint: "取消订单失败")
        }
        
    }
    
    // MARK: -- 付款下单
    func payBtnAction(model:OrderSheetServerModel){
        
        //MARK: --- 将请求地址与运费以及支付方式的接口
        showHud(in: self.view)
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            AlamofireNetWork.required(urlString: "/Simple_online/Address_PayWay_SendMoney", method: .post, parameters: ["UserNo": userNo, "Money":"\(model.All_Money)","cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
                
                let json = JSON(result)
                
                if json["resultStatus"] == "1" {
                    
                    self.hideHud()
                    
                    //用户支付方式的处理
                    let payWays = json["array2"].arrayObject as! [[String : String]]?
//                    //是否首单
//                    var isFirstOrder = "0"
//                    if let isF = json["isFirstOrder"].string, isF != "" {
//                        isFirstOrder = isF
//                    }
                    //运费
                    //let freightCost = "\(json["freight"].string ?? "0")"
                    let vc = OrderPay1VC()
                    vc.orderData = (model.cSheetno,model.Reality_All_Money.cgFloatString(),payWays ?? [])
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.showHint(in: self.view, hint: "请求出错")
                }
            }, failure: { (error) in
                self.showHint(in: self.view, hint: "请求出错")
            })
            
        }
        
    }
    
    // MARK: -- 联系卖家
    func connectBtnAction(model:OrderSheetServerModel) -> Void {
        
        let tel = model.cTel
        
        guard tel != "" else {
            showHint(in: view, hint: "商家未预留电话")
            return
        }
        
        UIApplication.shared.openURL(URL.init(string: "telprompt://\(tel)")!)
        
    }
    
}


