//
//  ShoppingCartVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kSettlementViewHeight:CGFloat = 49
private let kShoppingCartTableViewCellID = "kShoppingCartTableViewCellID"

class ShoppingCartVC: BaseViewController {
    
    dynamic var selectedIndexs:[Int] = []
    var dataSource:[ShopCartServerModel] = [] {
        didSet {
            if dataSource.count == 0 {
                self.navigationItem.rightBarButtonItem?.title = "编辑"
                self.emptyCartInfoView()
                self.type = .plusOrReduce
                self.isDelete = false
                self.tabBarItem.badgeValue = nil
            } else {
                self.tabBarItem.badgeValue = "\(getTotalGoodsCount())"
            }
        }
    }
    
    

    var setCheckBtn:UIButton?
    var isSetChecked:Bool = false
    
    
    //Mark: --- 初始化selectedIndex的值 
    func initialSelectedIndexs() {
        if dataSource.count != 0 {
            var tmpIndexs = [Int]()
            for i in 0..<dataSource.count {
                tmpIndexs.append(i)
            }
            self.selectedIndexs = tmpIndexs
        }
    }
    
    func getTotalGoodsCount() -> Int {
        if dataSource.count == 0 {
            return 0
        } else {
            var sum:Int = 0
            for model in dataSource {
                let num = (model.Num as NSString).integerValue
                sum += num
            }
            return sum
        }
        
    }
    
    //用来给tabbaritem反应下标值
    func valueChanged(notification:Notification){
        self.tabBarItem.badgeValue = (self.getTotalGoodsCount() == 0) ? nil :"\(self.getTotalGoodsCount())"
    }
    
    func getTotalMoney() -> Float {
        var total:Float = 0
        if selectedIndexs.count == 0 {
            return total
        }
        
        for i in selectedIndexs {
            let price = (dataSource[i].Last_Price as NSString).floatValue
            let num   = (dataSource[i].Num as NSString).floatValue
            total += price * num
        }
        
        return total
    }
    
    lazy var tableView:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kTabBarH - kSettlementViewHeight - kStatusBarH - kNavigationBarH)
        let tableview = UITableView.init(frame: rect, style: .plain)
        
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = BGCOLOR
        
        tableview.register(ShopCartVCTableCell.self, forCellReuseIdentifier: kShoppingCartTableViewCellID)
        return tableview
    }()
    
    lazy var settlementView:UIView = {[weak self]() -> UIView in
        //下部父视图
        let rect = CGRect(x: 0, y: kScreenH - kTabBarH - kSettlementViewHeight - kNavigationBarH - kStatusBarH, width: kScreenW, height: kSettlementViewHeight)
        let view = UIView.init(frame:rect)
        view.backgroundColor = UIColor.init(gray: 252)

        var totalMoney:CGFloat = 0
        if let total = self?.getTotalMoney() {
            totalMoney = CGFloat(total)
        }
        let totalStr = String(format: "%.2f", totalMoney)
        let subView = ShopCartSetmentView.init(frame: view.bounds,totalPrice:"\(totalStr)")
            subView.setClickClosure = {[weak self]()->Void in
                self?.requestDataForOrderPay()
        }
        
        subView.checkClosure = {[weak self](isChecked:Bool) ->Void in
            self?.operatTheAllCheck(ischecked: isChecked)
        }
        view.addSubview(subView)
        
        return view
    }()
    
    func requestDataForOrderPay(){
        
        //MARK: --- 将请求地址与运费以及支付方式的接口
        showHud(in: self.view)
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            AlamofireNetWork.required(urlString: "/Simple_online/Address_PayWay_SendMoney", method: .post, parameters: ["UserNo": userNo, "Money":"\(self.getTotalMoney())","cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
                
                let json = JSON(result)
                if json["resultStatus"] == "1" {
                    
                    self.hideHud()
                    
                    //addressModel处理
                    let addressArr = json["array1"].arrayObject
                    var addressModel: AddressUserModel?
                    if addressArr?.count != 0 {
                        addressModel = AddressUserModel.mj_object(withKeyValues: addressArr?[0])
                    }
                    //用户支付方式的处理
                    let payWays = json["array2"].arrayObject as! [[String : String]]?
                    //StoreModel处理
                    let storeArr = json["array3"].arrayObject
                    var storeModel: StoreModel?
                    if storeArr?.count != 0 {
                        storeModel = StoreModel.mj_object(withKeyValues: storeArr?[0])
                    }
                    //用户下单商品
                    var goodsArr: [[String:String]] = []
                    for (_,item) in self.selectedIndexs.enumerated() {
                        goodsArr.append(self.dataSource[item].beDict())
                    }
                    //是否首单
                    var isFirstOrder = "0"
                    if let isF = json["isFirstOrder"].string, isF != "" {
                        isFirstOrder = isF
                    }
                    //运费
                    let freightCost = "\(json["freight"].string ?? "0")"
                    let vc = OrderPayVC()
                    vc.orderData = ("",goodsArr,payWays ?? [],self.getTotalMoney(),(freightCost as NSString).floatValue,0,isFirstOrder,storeModel,addressModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    self.showHint(in: self.view, hint: "请求出错")
                }
                
            }, failure: { (error) in
                self.showHint(in: self.view, hint: "请求出错")
            })
            
        }

    }
    
    
    func operatTheAllCheck(ischecked:Bool) {
        if ischecked {
            self.selectedIndexs.removeAll()
            for (index, _) in (self.dataSource.enumerated()) {
                self.selectedIndexs.append(index)
                self.tableView.reloadData()
                self.postNotification()
            }
            
        } else {
            self.selectedIndexs.removeAll()
            self.tableView.reloadData()
            self.postNotification()
        }
    }
    
    
    func changeState() {
        if self.setCheckBtn != nil {
            if isSetChecked {
                setCheckBtn?.setImage(UIImage.init(named: "hlm_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                setCheckBtn?.setImage(UIImage.init(named: "hlm_disSelected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            isSetChecked = !isSetChecked
        }
        
    }
    
    
    func downloadImage(notification:Notification) {
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(letAllItemsCanDeleteAction))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes({[
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 16.0)!
            ]}(), for: .normal)
        
        
        NotificationCenter.default.addObserver(self,selector:#selector(requestData), name: NSNotification.Name(rawValue: userLoginOutActionNoficition), object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(requestData), name: NSNotification.Name(rawValue: goodsAddedToShopCart), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: NotiNameOfAfterChooseStore, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: NotiNameOfCommitOrder, object: nil)
        
        let notificationName = Notification.Name(rawValue: "valueChangedNotification")
        NotificationCenter.default.addObserver(self,selector:#selector(valueChanged(notification:)), name: notificationName, object: nil)
        
        //MARK: --- 添加观察者, 观察被选中数组的变化
        self.addObserver(self, forKeyPath: "selectedIndexs", options: NSKeyValueObservingOptions.new, context: nil)

        requestData()
    }
    
    //移除通知
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
    
   
    
    var type:GoodsControlType = .plusOrReduce
    var isDelete:Bool = false {
        didSet {
            if isDelete {
                //改变类型
                self.navigationItem.rightBarButtonItem?.title = "完成"
                
            } else {
                self.navigationItem.rightBarButtonItem?.title = "编辑"
            }
        }
    }
    
    func letAllItemsCanDeleteAction() {
        if dataSource.isEmpty {
            self.requestData()
            return
        }
        if dataSource.count == 0 {
            self.requestData()
            return
        }
        
        isDelete = !isDelete
        if isDelete {
        //改变类型
            self.type = .delete
            self.navigationItem.rightBarButtonItem?.title = "完成"
            
        } else {
            self.type = .plusOrReduce
            self.navigationItem.rightBarButtonItem?.title = "编辑"
        }
        
        self.tableView.reloadData()
    }

    func requestData() -> Void {
        
        dataSource = []
        selectedIndexs.removeAll()
        self.tableView.reloadData()
        
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            showHud(in: tableView)
            AlamofireNetWork.required(urlString: "/Simple_online/PF_Select_Shop_cart", method: .post, parameters: ["UserNo":userNo, "Number_of_pages":"1","cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { [weak self](results) in
                let json = JSON(results)
                if json["resultStatus"] == "1" {
                    let dictArray = json["dDate"].arrayObject
                    for aDict in dictArray! {
                        let aDict:[String:Any] = aDict as! [String : Any]
                        let model = ShopCartServerModel.init(dict: aDict)
                        self?.dataSource.append(model)
                    }
                    DispatchQueue.main.async(execute: {
                        
                        if self?.dataSource.count == 0 {
                            self?.emptyCartInfoView()
                        } else {
                            self?.operatTheAllCheck(ischecked: true)
                            self?.initialSelectedIndexs()
                            self?.view.addSubview((self?.tableView)!)
                            self?.view.addSubview((self?.settlementView)!)
                            self?.tableView.reloadData()
                        }
                        self?.hideHud()
                        
                    })
                    
                }
            }) { [weak self](error) in
                
                self?.emptyCartInfoView()
                self?.hideHud()
            }
        } else {
            emptyCartInfoView()
        }

    }
    
    //MARK: --- 实现观察者
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let notificationName = "SlectedIndexChanged"
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: self, userInfo: ["isempty":selectedIndexs.count == 0 ? true : false
            ,"isequal":selectedIndexs.count == dataSource.count ? true : false])
        
        if let keyPath = keyPath {
            if keyPath == "selectedIndexs" {
                
                if selectedIndexs.count == 0 {
                    
                    self.setCheckBtn?.isEnabled = false
                    self.setCheckBtn?.alpha = 0.5
                } else {
                    self.setCheckBtn?.isEnabled = true
                    self.setCheckBtn?.alpha = 1
                }
                
            }
        }
        
        
    }
    
    func emptyCartInfoView() {
        
        _ = view.subviews.map{$0.removeFromSuperview()}
        
        let imageview = UIImageView.init(image: UIImage.init(named: "empty_shopcart_girl"))
        let shopBtn = UIButton.init(type: .system)
        shopBtn.setTitle("去购物", for: .normal)
        shopBtn.setTitleColor(UIColor.white, for: .normal)
        
        shopBtn.layer.cornerRadius = 3
        shopBtn.layer.masksToBounds = true
        shopBtn.layer.backgroundColor = UIColor.appMainColor().cgColor
        
        shopBtn.addTarget(self, action: #selector(goShopping), for: .touchUpInside)
        
        let titleLabel = UILabel.init()
        titleLabel.textColor = UIColor.init(gray: 200)
        titleLabel.text = "购物车没有商品"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(imageview)
        self.view.addSubview(shopBtn)
        self.view.addSubview(titleLabel)
        //布局
        let ratio = CGFloat(840/746)
        imageview.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.618)
            make.width.equalToSuperview().multipliedBy(0.618)
            make.height.equalTo(imageview.snp.width).multipliedBy(ratio)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageview.snp.bottom).offset(10)
            make.width.equalTo(imageview).dividedBy(2)
            make.height.equalTo(shopBtn.snp.width).dividedBy(3)
        }
        shopBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalTo(imageview).dividedBy(2)
            make.height.equalTo(shopBtn.snp.width).dividedBy(3)
        }
    }
    
    
    func goShopping() {
        //let window:UIWindow = UIApplication.shared.keyWindow!
        let rootVC = TabBarController.shareTabBarController
        rootVC.selectedIndex = 1
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
//MARK: --- Vaule

extension ShoppingCartVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ShopCartVCTableCell = tableView.dequeueReusableCell(withIdentifier: kShoppingCartTableViewCellID, for: indexPath) as! ShopCartVCTableCell
       
        let serverModel = self.dataSource[indexPath.row]
        cell.cellID = indexPath.row
        cell.delegate = self
        cell.type = type
        if selectedIndexs.contains(indexPath.row) {
            cell.isChecked = true
        } else {
            cell.isChecked = false
        }
        
        //选中或者没选中影响的状态
        cell.addClosure = { (cellID:Int) in
            if !self.selectedIndexs.contains(cellID) {
                self.selectedIndexs.append(cellID)
                self.postNotification()
            }
        }
        cell.reduceClosure = { (cellID:Int) in
            if self.selectedIndexs.contains(cellID) {
                let index = self.selectedIndexs.index(of: cellID)
                self.selectedIndexs.remove(at: index!)
                self.postNotification()
            }
        }
        
        cell.model = ShopCartGoodModel.init(dict: ["name":serverModel.cGoodsName, "price":serverModel.Last_Price, "avtarImage":serverModel.cGoodsImagePath, "count":serverModel.Num, "isSelected": false])
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ShopCartVCTableCell
        cell.checkBoxBtn.tag = 1000 + indexPath.row * 4
    }
    
    func postNotification() {
        let notificationName = Notification.Name(rawValue: "valueChangedNotification")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["totalMoney":"\(self.getTotalMoney())"])
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ShopCartVCTableCell
        
        cell.isChecked = !cell.isChecked!
    }
    
}


extension ShoppingCartVC:ShopCartVCTableCellDelegate {
    
    internal func deleteItemAction(cellID: Int) {
        //对购物车进行删除操作
        let alertVC = UIAlertController.init(title: "是否确定删除", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction:UIAlertAction) in
            //1. 从本地数据源中删除数据
            let model   = self.dataSource[cellID]
            let goodsNo = model.cGoodsNo
          
            //3. 网络发送请求,说明该数据被删除
            if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
                AlamofireNetWork.required(urlString: "/Simple_online/Delete_Shop_Car", method: .post, parameters: ["UserNo":userNo, "cGoodsNo":goodsNo,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
                    let json = JSON(result)
                    if json["resultStatus"] == "1" {
                        self.showHint(in: self.view, hint: "删除成功")
                        //请求删除成功之后, 再从本地删除数据
                        self.dataSource.remove(at: cellID)
                        
                        //1.1 如果cell被选中, 那么从被选中的数组中移除
                        if self.selectedIndexs.contains(cellID) {
                            let index = self.selectedIndexs.index(of: cellID)
                            self.selectedIndexs.remove(at: index!)
                        }
                        self.selectedIndexs = self.selectedIndexs.map{$0 >= cellID ?($0 - 1) : $0}
                        self.postNotification()

                        //2. 刷新视图
                        
                        self.tableView.deleteRows(at: [IndexPath.init(item: cellID, section: 0)], with: .left)
                        self.tableView.reloadData()
                        
                    } else {
                        self.showHint(in: self.view, hint: "请求异常,删除失败")
                    }
                }, failure: { (error) in
                    NSLog(error.localizedDescription)
                })
            }
            
            
           
            
        }
        
        let  cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (alertAction:UIAlertAction) in
        }
        
        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
        
        
    }

    internal func numberButtonResult(_ numberButton: PPNumberButton, number: String, cellID: Int) {
        let model = self.dataSource[cellID]
        
        self.postNotification()
        let fage = model.Num > number ? "0" :"1"
        //ppbutton改变时, 进行网络请求
        
        model.Num = number
        
        self.showHud(in: self.view)
        
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            AlamofireNetWork.required(urlString: "/Simple_online/Shop_Car_Add_Subtract", method: .post, parameters: ["UserNo":userNo, "cGoodsNo":model.cGoodsNo, "fage":fage,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
                print(result)
                let json = JSON(result)
                if json["resultStatus"] == "1"{
                    self.hideHud()
                    model.Last_Price = json["dDate"]["Last_Price"].string!
                    self.tableView.reloadRows(at: [IndexPath.init(row: cellID, section: 0)], with: UITableViewRowAnimation.fade)
                }else {
                    self.showHint(in: self.view, hint: "加减数量失败")
                    let old = fage == "0" ? Int(Double(model.Num)!) + 1 : Int(Double(model.Num)!) - 1
                    model.Num = "\(old)"
                    numberButton.rebackOldNumber(number: old)
                }
                self.postNotification()
            }) { (error) in
                self.showHint(in: self.view, hint: "加减数量失败")
                let old = fage == "0" ? Int(Double(model.Num)!) + 1 : Int(Double(model.Num)!) - 1
                model.Num = "\(old)"
                numberButton.rebackOldNumber(number: old)
                self.postNotification()
            }
        }
    }
}










