//
//  GoodsDetailVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/7/21.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let kBottomViewH:CGFloat = 49

class GoodsDetailVC: BaseViewController {
    
    fileprivate var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 10 , y: 30, width: 36, height: 36))
        btn.setImage(UIImage.init(named: "hlm_back_icon"), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: "hlm_back_icon"), for: UIControlState.selected)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var list:UITableView  = {[weak self] in
        let rect = CGRect.init(x: 0, y: -kStatusBarH, width: kScreenW, height: kScreenH+kStatusBarH-kBottomViewH)
        let list = UITableView.init(frame: rect, style: .grouped)
        list.backgroundColor = UIColor.init(gray: 244);
        list.delegate = self
        list.dataSource = self
        list.separatorStyle = .none
        list.showsVerticalScrollIndicator = false
        
        list.register(UINib.init(nibName: "GoodsDetailTCell", bundle: nil), forCellReuseIdentifier: "GOODDETAILCELLID")
        list.register(UITableViewCell.self, forCellReuseIdentifier: "COMMONCELL")
        list.register(GoodsDetailDesTCell.self, forCellReuseIdentifier: "COMMONCELLDETAIL")
        
        return list
        }()
    
    fileprivate lazy var bottomView: UIView = { [weak self] in
        
        let view = UIView(frame: CGRect(x: 0, y: self!.list.frame.maxY, width: kScreenW, height: kBottomViewH))
        view.backgroundColor = UIColor.white
        
        let nameArr = ["购物车"]
        let imageArr = [#imageLiteral(resourceName: "购物车")]
        
        for i in 0..<nameArr.count {
            let btn = HLTopBtn(frame: CGRect(x: 70*i, y: 0, width: 70, height: Int(kBottomViewH)))
            btn.setTitle(nameArr[i], for: .normal)
            btn.setImage(imageArr[i], for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.setTitleColor(UIColor.colorFromHex(0x8b8b8b), for: .normal)
            btn.tag = i+1
            btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
            btn.contentHorizontalAlignment = .center
            view.addSubview(btn)
        }
        
        let leftX = CGFloat(70*nameArr.count)
        
        let btn1 = UIButton(frame: CGRect(x: leftX, y: 0, width: (kScreenW-leftX)/2, height: kBottomViewH))
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn1.backgroundColor = UIColor.colorFromHex(0xfebf15)
        btn1.setTitle("加入购物车", for: .normal)
        btn1.setTitleColor(UIColor.white, for: .normal)
        btn1.tag = nameArr.count + 1
        btn1.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        view.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRect(x: leftX+(kScreenW-leftX)/2, y: 0, width: (kScreenW-leftX)/2, height: kBottomViewH))
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn2.backgroundColor = UIColor.colorFromHex(0xF02B2B)
        btn2.setTitle("立即购买", for: .normal)
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.tag = nameArr.count + 2
        btn2.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        view.addSubview(btn2)
        
        return view
        
        }()
    
    //Mark: --- 商品是否收藏标识
//    var isCollect:Bool? = false {
//        didSet{
//            if let isCollect = self.isCollect {
//                var imageName = ""
//                var str = ""
//                if isCollect {
//                    imageName = "hlm_goodsDetail_collect_didSelect"
//                    str = "已收藏"
//                }else {
//                    imageName = "hlm_goodsDetail_collect"
//                    str = "收藏"
//                }
//
//                let btn = self.bottomView.viewWithTag(1) as! UIButton
//                btn.setImage(UIImage.init(named: imageName), for: .normal)
//                btn.setTitle(str, for: .normal)
//            }
//        }
//    }

    fileprivate var isHaveSelectNum = false
    
    var cGoodsNo:String?
    var model:GoodsDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
    
        self.view.addSubview(bottomView)
        self.view.addSubview(backBtn)
        
        changeBtnState(state: false)
        
        requestData()
    }
    
    func changeBtnState(state: Bool) -> Void {
        for i in 1...3 {
            let btn = self.bottomView.viewWithTag(i) as! UIButton
            btn.isUserInteractionEnabled = state
        }
    }
    
    func requestData() {
        
        var userNo = ""
        if let user = UserAuthManager.sharedManager.getUserModel() {
            userNo = user.UserNo
        }
        
        AlamofireNetWork.required(urlString: "/Simple_online/PF_Select_GoodsDetail_cStore", method: .post, parameters: ["cGoodsNo":self.cGoodsNo ?? "","UserNo":userNo,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { results in
            let json = JSON(results)
            if json["resultStatus"] == "1" {
                self.view.addSubview(self.list)
                self.view.bringSubview(toFront: self.backBtn)
                self.changeBtnState(state: true)
                let modelArr = GoodsDetailModel.mj_objectArray(withKeyValuesArray: json["dDate"].arrayObject) as! [GoodsDetailModel]
                self.model = modelArr[0]
                self.list.reloadData()
            } else {
                self.showHint(in: self.view, hint: "商品信息丢失")
            }
        }) { (error) in
            print(error)
        }
    }
}

// MARK: - 事件响应
extension GoodsDetailVC {
    // MARK: - 返回事件
    func backAction() -> Void {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - 底部菜单按钮点击事件
    func btnAction(btn: UIButton) -> Void {
        
        guard UserAuthManager.sharedManager.getUserModel()?.UserNo != nil else {
            let alertVC = UIAlertController.init(title: "您还没有登录", message: nil, preferredStyle: .alert)
            let toLogin = UIAlertAction.init(title: "去登录", style: .default, handler: { (action) in
                let loginVC = LoginViewController()
                let rootVC = TabBarController.shareTabBarController
                rootVC.selectedIndex = 3
                
                let profileNavVC:NavigationController = rootVC.childViewControllers.last as! NavigationController
                profileNavVC.pushViewController(loginVC, animated: true)
            })
            let notNow = UIAlertAction.init(title: "暂不登录", style: .cancel, handler: { (action) in
                
            })
            alertVC.addAction(toLogin)
            alertVC.addAction(notNow)
            
            TabBarController.shareTabBarController.present(alertVC, animated: true, completion: nil)
            return
        }
        
        switch btn.tag {
        case 1:
            self.navigationController?.tabBarController?.selectedIndex = 2
        case 2:
            let goodsDetailView = GoodsDetailView.init(model:self.model!)
            goodsDetailView.type = GoodsDetailViewType.addShopCart
            goodsDetailView.doActionBlock = { (count,price) in
                self.model?.SelectNum = "\(count)"
                self.model?.SelectPrice = price
                self.list.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: UITableViewRowAnimation.none)
                self.btn3()
            }
            
        case 3:
            let goodsDetailView = GoodsDetailView.init(model:self.model!)
            goodsDetailView.type = GoodsDetailViewType.shoppingNow
                goodsDetailView.doActionBlock = { (count,price) in
                    self.model?.SelectNum = "\(count)"
                    self.model?.SelectPrice = price
                    self.list.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: UITableViewRowAnimation.none)
                    self.btn4()
            }
            
            
        default:
            break
        }
    }
//    // MARK: -- 收藏
//    func btn1(sender:UIButton) -> Void {
//        let userNo = UserAuthManager.sharedManager.getUserModel()!.UserNo
//        AlamofireNetWork.required(urlString: "/Simple_online/Goods_Collection", method: .post, parameters: ["UserNo": userNo, "cGoodsNo": self.model!.cGoodsNo,"fage":self.isCollect == true ? "0" : "1","cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
//            
//            let str = self.isCollect == true ? "取消收藏" : "收藏"
//            
//            let json = JSON(result)
//            if json["resultStatus"] == "1" {
//                self.isCollect = !self.isCollect!
//                self.showHint(in: self.view, hint: "\(str)成功")
//                
//                //发送通知, 告知个人中心页面, 改变收藏个数
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: goodsCollectCountChanged), object: self, userInfo: [:])
//                
//            }else if json["resultStatus"] == "2" {
//                self.showHint(in: self.view, hint: "该商品已经被\(str)啦")
//            }else{
//                self.showHint(in: self.view, hint: "\(str)失败")
//            }
//            
//        }, failure: { (error) in
//            self.showHint(in: self.view, hint: "操作失败")
//        })
//    }
    // MARK: -- 加入购物车
    func btn3() -> Void {
        let userNo = UserAuthManager.sharedManager.getUserModel()!.UserNo
        
        AlamofireNetWork.required(urlString: "/Simple_online/PF_Upload_Shop_cart", method: .post, parameters: ["UserNo": userNo, "cGoodsNo": self.model!.cGoodsNo, "cStoreNo":UserStoreManager.sharedManager.getStoreNo(),"Num":self.model!.SelectNum], success: { (result) in

            let json = JSON(result)
            if json["resultStatus"] == "1" {
                self.showHint(in: self.view, hint: "加入购物车成功")
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: goodsAddedToShopCart), object: self, userInfo: [:])
            }else{
                self.showHint(in: self.view, hint: "加入购物车失败")
            }
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "加入购物车失败")
        })
    }
    // MARK: -- 立即购买
    func btn4() -> Void {
        //MARK: --- 将请求地址与运费以及支付方式的接口
        showHud(in: self.view)
        let userNo = UserAuthManager.sharedManager.getUserModel()!.UserNo
        
        let money = CGFloat(Double((self.model?.SelectNum)!)!) * CGFloat(Double((self.model?.SelectPrice)!)!)
        
        AlamofireNetWork.required(urlString: "/Simple_online/Address_PayWay_SendMoney", method: .post, parameters: ["UserNo": userNo, "Money":"\(money)","cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
            
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
                let goodsArr: [[String:String]] = [["cGoodsImagePath":self.model!.cGoodsImagePath,"Last_Price":self.model!.SelectPrice,"Last_Money":"\(money)","cGoodsName":self.model!.cGoodsName,"cGoodsNo":self.model!.cGoodsNo,"Num":self.model!.SelectNum]]
                //是否首单
                var isFirstOrder = "0"
                if let isF = json["isFirstOrder"].string, isF != "" {
                    isFirstOrder = isF
                }
                //运费
                let freightCost = "\(json["freight"].string ?? "0")"
                let vc = OrderPayVC()
                
                vc.orderData = ("",goodsArr,payWays ?? [],Float(money),(freightCost as NSString).floatValue,0,isFirstOrder,storeModel,addressModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showHint(in: self.view, hint: "请求出错")
            }
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "请求出错")
        })
        
    }
}

extension GoodsDetailVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GOODDETAILCELLID", for: indexPath) as! GoodsDetailTCell
            cell.model = self.model
            return cell
        case 1:
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "COMMONCELL")
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "已选"
            cell.textLabel?.textColor = UIColor.colorFromHex(0x8b8b8b)
            cell.detailTextLabel?.text = self.model!.cSpec + "  x " + self.model!.SelectNum + self.model!.cUnit
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "COMMONCELLDETAIL", for: indexPath) as! GoodsDetailDesTCell
            cell.textView.text = self.model?.Description
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let goodsDetailView = GoodsDetailView.init(model:self.model!)
            goodsDetailView.doActionBlock = { (count,price) in
                self.isHaveSelectNum = true
                self.model?.SelectNum = "\(count)"
                self.model?.SelectPrice = price
                self.list.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: UITableViewRowAnimation.none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 220
        case 1:
            return 50
        case 2:
            let height = self.model?.Description.boundingRect(with: CGSize.init(width: kScreenW - WID, height: kScreenH), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil).size.height
            return (height ?? -20) + 20
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0.00001
        }else{
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return kScreenW
        }else if section == 2 {
            return 50
        }else {
            return 0.00001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = GoodsDetailHeaderView()
            let defaultImageModel = GoodsImageModel()
            defaultImageModel.cGoodsImagePath = (self.model?.cGoodsImagePath)!
            
            if self.model?.cGoodsImages.count != 0 {
                headerView.setHeaderImages(images: self.model!.cGoodsImages)
            }else{
                headerView.setHeaderImages(images: [defaultImageModel])
            }
            
            return headerView
        }else if section == 2 {
            let headerView = UIView.init()
            headerView.backgroundColor = UIColor.white
            
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 44))
            label.text = "商品介绍"
            
            let grayView = UIView(frame: CGRect(x: 0, y: 44, width: kScreenW, height: _1pxWidth))
            grayView.backgroundColor = UIColor.init(gray: 210)
            
            headerView.addSubview(label)
            headerView.addSubview(grayView)
            
            return headerView
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init()
        footerView.backgroundColor = UIColor.colorFromHex(0xf3f3f6)
        return footerView
    }

}


// MARK: -- UINavigationControllerDelegate(隐藏、显示NavigationBar的动画)
extension GoodsDetailVC:UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isGoodsDetailVC = viewController.isKind(of: GoodsDetailVC.self)
        self.navigationController?.setNavigationBarHidden(isGoodsDetailVC, animated: true)
    }
}
