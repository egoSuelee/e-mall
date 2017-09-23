//
//  NewHomeVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/5/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

let CViewCellMargin: CGFloat = 8//collectionView的cell之间的间隔
let CViewCellWid: CGFloat = (kScreenW - 5 * 8)/4//collectionView的cell宽度
let CViewCellHei: CGFloat = 80//collectionView的cell宽度
let CViewCellWid1: CGFloat = (kScreenW - 3 * 8)/2//collectionView的cell宽度
func CViewCeil(_ count: Int, _ divisor: Int) -> CGFloat{return CGFloat(ceil(Float(count)/Float(divisor)))}//数组count除以divisor在向上取整
let ClassifyTypeColViewID = "ClassifyTypeColViewID"
let ClassifyTypeColViewCellID = "ClassifyTypeColViewCellID"
let VADColViewID = "VADColViewID"
let VADColViewCellID = "VADColViewCellID"

class NewHomeVC: AnimationVC {
    
    var eventPage:UIView?
    
    //轮播图 图片网址数组/图片名字数组/偏移量/以及轮播图高度
    fileprivate lazy var imageUrls = [String]()
    fileprivate lazy var imageNames = [String]()

    //按钮title/titleImage
    let headerBtnTitleArray = [("我常买", "changmai"),
                               ("热销排行","rexiao"),
                               ("折扣精品", "zhekou"),
                               ("特产", "techan")]
    var homeBtnCounts:Int {
        get {
            return headerBtnTitleArray.count
        }
    }
    var homeHeaderH:CGFloat  {
        get {
            return kScreenH/4 + kScreenW/4 * CGFloat(Int(homeBtnCounts/4)) + 15 + 8
        }
    }
    
    fileprivate lazy var homeHeaderView:HomeVCTableHeaderView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: (self?.homeHeaderH)!)
        let headerView = HomeVCTableHeaderView.init(frame: rect, btnCounts: (self?.homeBtnCounts)!, target: self!)
        headerView.delegate = self
        return headerView
    }()
    
    var carouselArr: [ShopCartStyleModel]? {
        didSet {
            guard carouselArr != nil else {
                return
            }
            configureCarouselData()
        }
    }
    
    func configureCarouselData() {
        if let carouselData = carouselArr {
            self.imageUrls = []
            self.imageNames = []
            let redirectImageHAdUrl = URLManager.sharedURLManager.ImageHAdUrl
            for model in carouselData {
                self.imageUrls.append((redirectImageHAdUrl != nil ? redirectImageHAdUrl! : ImageHAdUrl) + model.cGoodsImagePath)
                self.imageNames.append(model.describe)
            }
            self.homeHeaderView.carouselView.reload(withImageArray: self.imageUrls, describe: self.imageNames)
        }
    }
    
    var listsGoodsArr = [HomeListGoodsModel]()
    
    var salesGoodsArr = [ShopCartStyleModel]()
    
    fileprivate lazy var homeTableView: UITableView? = {
        let tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-kStatusBarH-kNavigationBarH-kTabBarH), style: UITableViewStyle.grouped)
        //注册cellID
        tableView.register(HomeVCADTableCell.self, forCellReuseIdentifier: "HomeTVCADELLID")
        tableView.register(HomeVCTableCell.self, forCellReuseIdentifier: "HomeTVCELLID")
        //隐藏滑块
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorFromHex(0xf6f5f5)
        return tableView
    }()
    
    var storeBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //禁止自动调整(顶部不保留每个section的header)
        automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(homeTableView!)
        homeTableView?.tableHeaderView = homeHeaderView
        
        
        let searchBtn = SearchBtn(frame: CGRect(x: 0, y: 0, width: kScreenW*4/5, height: 30))
        searchBtn.addTarget(self, action: #selector(searchBtnAction), for: .touchUpInside)
        searchBtn.backgroundColor = UIColor.sharedImageColor()
        self.navigationItem.titleView = searchBtn
        
        
        //添加下拉刷新控件
        let refreshHeader = MJRefreshGifHeader { [weak self] in
            self?.requestData()
        }
        
        refreshHeader?.setImages([UIImage.init(named: "icon_hud_1_107x66_")!,
                                  UIImage.init(named: "icon_hud_2_107x66_")!,
                                  UIImage.init(named: "icon_hud_3_107x66_")!,
                                  UIImage.init(named: "icon_hud_4_107x66_")!,
                                  UIImage.init(named: "icon_hud_5_107x66_")!,
                                  UIImage.init(named: "icon_hud_6_107x66_")!,
                                  UIImage.init(named: "icon_hud_7_107x66_")!,
                                  UIImage.init(named: "icon_hud_8_107x66_")!],
                                 duration: 1,
                                 for: MJRefreshStateRefreshing)
        
        homeTableView?.header = refreshHeader
        homeTableView?.header.beginRefreshing()
        
        configureStoreBtn()
        configureLocationBtn()
        //MARK: --- 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(afterChooseStoreAction), name: NotiNameOfAfterChooseStore, object: nil)
        
        //Mark: --- 加载新用户活动9折
        loadEvents()
    }
    
    func searchBtnAction() {
        let vc = SearchVC()
        vc.title = "搜索"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func afterChooseStoreAction() {
        self.storeBtn?.setTitle(UserStoreManager.sharedManager.getStoreName(), for: UIControlState.normal)
//        //退出登录
//        UserAuthManager.sharedManager.cleanUserInfo()
//        if UserAuthManager.sharedManager.getUserModel() == nil {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: userLoginOutActionNoficition), object: self,userInfo: ["UserActionType":HLUserAction.logOut])
//        }
        //删除缓存数据
        let fileManager = FileManager.default
        let homeUrl = SavePlistfilename(filename: "HomeData1.plist")
        let rightTopUrl = SavePlistfilename(filename: "RightTopData.plist")
        let leftUrl = SavePlistfilename(filename: "LeftArrData.plist")
        let rightUrl = SavePlistfilename(filename: "RightArrData.plist")
        try? fileManager.removeItem(atPath: homeUrl)
        try? fileManager.removeItem(atPath: rightTopUrl)
        try? fileManager.removeItem(atPath: leftUrl)
        try? fileManager.removeItem(atPath: rightUrl)
        homeTableView?.header.beginRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureStoreBtn() {
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        
        let storeBtn = UIButton.init(frame: CGRect(x: -20, y: 0, width: 60, height: 44))
        storeBtn.setTitle(UserStoreManager.sharedManager.getStoreName(), for: UIControlState.normal)
        storeBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        storeBtn.titleLabel?.numberOfLines = 2
        storeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        storeBtn.addTarget(self, action: #selector(storeBtnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItems = [negativeSpacer,UIBarButtonItem.init(customView: storeBtn)]
        
        self.storeBtn = storeBtn
    }
    
    func storeBtnAction() {
        let storeVC = ChooseStoreVC()
        storeVC.type = 1
        self.navigationController?.pushViewController(storeVC, animated: true)
    }
    
    func configureLocationBtn() {
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        
        let locationBtn = UIButton.init(type: .custom)
        locationBtn.setImage(UIImage(named: "dingwei"), for: .normal)
        locationBtn.sizeToFit()
        locationBtn.frame.size = CGSize(width: 30, height: 30)
        locationBtn.addTarget(self, action: #selector(showLocationAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [negativeSpacer,UIBarButtonItem.init(customView: locationBtn)]
    }
    
    func showLocationAction() {
        let showLocationVC = ShowLocationVC()
        self.navigationController?.pushViewController(showLocationVC, animated: true)
    }
    
   
    func requestData() {
       
        AlamofireNetWork.required(urlString: "/Simple_online/Select_HomePage_Info_cStore", method: .post, parameters: ["cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
            
            self.homeTableView?.header.endRefreshing()
            
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                self.transformJson(json: json["dDate"])
                //数据返回成功 保存plist到沙盒中
                savePlist(data: result as AnyObject,filename: "HomeData1.plist")
            } else {
                ///数据返回失败 从沙盒中获取
                if getPlist(filename: "HomeData1.plist").state == true {
                    var resultDict = JSON.null
                    resultDict = JSON(getPlist(filename: "HomeData1.plist").plist)
                    if resultDict != JSON.null {
                        self.transformJson(json: resultDict["dDate"])
                    }
                }
            }
            
        }) { (error) in
            self.homeTableView?.header.endRefreshing()
            ///数据返回失败 从沙盒中获取
            if getPlist(filename: "HomeData1.plist").state == true {
                var resultDict = JSON.null
                resultDict = JSON(getPlist(filename: "HomeData1.plist").plist)
                if resultDict != JSON.null {
                    self.transformJson(json: resultDict["dDate"])
                }
            }
        }
    }
    
    func transformJson(json:JSON) {
        
        carouselArr = ShopCartStyleModel.mj_objectArray(withKeyValuesArray: json["carousel"].arrayObject).copy() as? [ShopCartStyleModel]
        listsGoodsArr = (HomeListGoodsModel.mj_objectArray(withKeyValuesArray: json["listsGoods"].arrayObject).copy() as? [HomeListGoodsModel])!
//        salesGoodsArr = 
        
        self.homeTableView?.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}


extension NewHomeVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //去掉轮播图的数据
        return self.listsGoodsArr.count == 0 ? 0 : self.listsGoodsArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCADELLID", for: indexPath) as! HomeVCADTableCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCELLID", for: indexPath) as! HomeVCTableCell
            cell.targetVC = self
            cell.models = self.listsGoodsArr[indexPath.section - 1].goodsData
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return kScreenW/3
        }else {
            return (kScreenW / 3) * 1.6
        }
    }
    
    //Section 头部视图
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else {
            let model = self.listsGoodsArr[section - 1]
            let rect = CGRect(x: 0, y: 0, width: kScreenW, height: 50)
            let headerView = HomeSectionHeaderView.init(frame: rect, title: model.type, titleImageName: section == 1 ? "装饰圆" : "装饰圆2", titleColor: section == 1 ? UIColor.colorFromHex(0x25e6b8) : UIColor.colorFromHex(0xc674e6))
            return headerView
        }
    }
    
    //Section 底部视图
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension NewHomeVC:HomeVCTableHeaderViewDelegate {
    func homeVCHeaderCarouselView(_ carouselView: XRCarouselView!, clickImageAt index: Int) {
        
        guard carouselArr != nil,carouselArr?.count != 0 else {
            return
        }

        let model = carouselArr![index]
        
        let vc = GoodsDetailVC()
        vc.cGoodsNo = model.cGoodsNo
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func homeVCHeaderConfigure(btns:[HLTopBtn]) {
        for btn in btns {
            btn.setTitle(headerBtnTitleArray[btn.tag].0, for: .normal)
            btn.setImage(UIImage.init(named: headerBtnTitleArray[btn.tag].1), for: .normal)
        }
    }
    
    func homeVCHeaderBtns(_ btn:HLTopBtn, clickBtnAt index:Int) {
        switch index {
        case 0:
            
            guard UserAuthManager.sharedManager.getUserModel()?.UserNo != nil else {
                let alertVC = UIAlertController.init(title: "您还没有登录", message: nil, preferredStyle: .alert)
                let toLogin = UIAlertAction.init(title: "去登录", style: .cancel, handler: { (action) in
                    let loginVC = LoginViewController()
                    let rootVC = TabBarController.shareTabBarController
                    rootVC.selectedIndex = 3
                    let profileNavVC:NavigationController = rootVC.childViewControllers.last as! NavigationController
                    profileNavVC.pushViewController(loginVC, animated: true)
                    
                })
                let notNow = UIAlertAction.init(title: "暂不登录", style: .default, handler: { (action) in
                    
                })
                alertVC.addAction(notNow)
                alertVC.addAction(toLogin)
                
                
                TabBarController.shareTabBarController.present(alertVC, animated: true, completion: nil)
                return
            }
            
            let vc = HomeOftenGoodsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = HomeHotSales()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = HomeDiscountGoodsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = HomeSpecialtyGoodsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            showHint(in: self.view, hint: "功能正在建设中...")
            break
        }
    }
}

extension NewHomeVC {
    //Mark: --- 每次进入之后再UIWindow加载活动提示
    
    func _loadEvents() {
        let maskView = UIButton.init(type: .custom)
        maskView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        maskView.backgroundColor = UIColor.init(gray: 0).withAlphaComponent(0.7)
        self.eventPage = maskView
        let eventImageView:UIImageView = {_ in
            let eventH = (kScreenW - 40)*0.733
            let rect = CGRect.init(x: 20, y: 150, width: kScreenW - 40, height: eventH)
            let imageView = UIImageView.init(frame: rect)
            imageView.image = UIImage.init(named: "nine_off_ad")
            return imageView
        }()
        
        let closeBtn:UIButton = {[weak self] in
            let closeBtn = UIButton.init(type: .custom)
            closeBtn.frame = CGRect.init(x: kScreenW - 64, y: 100, width: 44, height: 44)
            closeBtn.setImage(UIImage.init(named: "nineoff_closeBtn"), for: .normal)
            closeBtn.setImage(UIImage.init(named: "nineoff_closeBtn"), for: .highlighted)
            closeBtn.addTarget(self, action: #selector(self?.closeEventPage), for: .touchUpInside)
            return closeBtn
            }()
        
        let marginH = (kScreenW - 40)*0.733 + 150 + 30
        
        let registerBtn:UIButton = {[weak self] in
            let registerBtn = UIButton.init(type: .custom)
            registerBtn.frame = CGRect.init(x: (kScreenW-222)/2, y: marginH, width: 222, height: 70)
            registerBtn.setImage(UIImage.init(named: "register_rightnow_btn"), for: .normal)
            registerBtn.setImage(UIImage.init(named: "register_rightnow_btn"), for: .highlighted)
            registerBtn.addTarget(self, action: #selector(self?.toRegisterVC), for: .touchUpInside)
            return registerBtn
            }()
        maskView.addSubview(eventImageView)
        maskView.addSubview(closeBtn)
        maskView.addSubview(registerBtn)
        
        UIApplication.shared.keyWindow?.addSubview(maskView)
        userDefault.set(NSDate.getToday()!, forKey: "KISLOADEVENTTODAY")
    }
    
    func loadEvents() {
        
        let  isLoadEventsToday = userDefault.value(forKey: "KISLOADEVENTTODAY")
        if let isLoadEventsToday = isLoadEventsToday {
            let _string = isLoadEventsToday as! String
            if _string == NSDate.getToday()! {
                return
            } else {
                _loadEvents()
            }
        } else {
            _loadEvents()
        }
    }
    
    func closeEventPage() {
        self.eventPage?.alpha = 0
        self.eventPage?.removeFromSuperview()
    }
    
    func toRegisterVC() {
        self.closeEventPage()
        let loginVC = LoginViewController()
        //let window:UIWindow = UIApplication.shared.keyWindow!
        let rootVC = TabBarController.shareTabBarController
        rootVC.selectedIndex = 3
        if(UserAuthManager.sharedManager.isUserLogin()){
        } else {
            let profileNavVC:NavigationController = rootVC.childViewControllers.last as! NavigationController
            profileNavVC.pushViewController(loginVC, animated: true)
        }
    }
    
}
