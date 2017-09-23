//
//  CategoryDetailVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/7/25.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let kCategoryDetailVCCellID = "kCategoryDetailVCCellID"

class CategoryDetailVC: BaseViewController {
    
    fileprivate var leftArr = Array<ClassifyTypeModel>()
    
    fileprivate var rightArr = Array<ShopCartStyleModel>()
    
    fileprivate var currentPage = 1
    
    fileprivate var isLoad = false
    
    fileprivate var currentLeftModel: ClassifyTypeModel?

    lazy var titleView:HL_RightBtn = {[weak self] in
        let btn = HL_RightBtn.init(frame: CGRect.init(x: 0, y: 0, width: 4*WID, height: 30))
        btn.setImage(UIImage.init(named: "sanjiao"), for: .normal)
        btn.setTitleColor(UIColor.appNavBarTitleColor(), for: .normal)
        btn.addTarget(self, action: #selector(selectGoodsType), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleDropMenu:DropMenu = {[weak self] in
        
        let drop = DropMenu.init(frame: CGRect.init(x: 0, y: -1, width: kScreenW, height: kScreenH*0.6), target: (self?.view)!)
        drop.delegate = self
        drop.backgroundColor = UIColor.white
        return drop
        }()

    
    func selectGoodsType() {
        guard let state = self.titleDropMenu.state else {
            return
        }
        switch state {
        case .close:
            titleDropMenu.showOrHideMenu(isShow: true)
            UIView.animate(withDuration: kDropMenuAnimDur, animations: {
                self.titleView.imageView?.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
            })
        default:
            titleDropMenu.showOrHideMenu(isShow: false)
            UIView.animate(withDuration: kDropMenuAnimDur, animations: {
                self.titleView.imageView?.transform = CGAffineTransform.init(rotationAngle: CGFloat(0))
            })
        }
    }
    
    fileprivate lazy var leftTableView: ClassifyLeftTableView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW * 0.2, height: kScreenH - kStatusBarH - kNavigationBarH)
        let leftTableView = ClassifyLeftTableView(frame: rect)
        leftTableView.titleBlock = { [weak self] data in
            let model = data as! ClassifyTypeModel
            return model.cGroupTypeName
        }
        leftTableView.selectBlock = { [weak self] (data,index) in
            self!.selectLeftTableView(model: data as! ClassifyTypeModel, index: index)
        }
        return leftTableView
    }()
    
    fileprivate lazy var rightGoodsView: UITableView = {
        let rect = CGRect(x: 0.2 * kScreenW, y: 0, width: kScreenW * 0.8, height: kScreenH - kStatusBarH - kNavigationBarH)
        let tableView = UITableView.init(frame: rect, style: .grouped)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(CategoryDetailCell.self, forCellReuseIdentifier: kCategoryDetailVCCellID)
        return tableView
    }()
    
    
    var listDataSource:[ClassifyTypeModel]? {
        didSet{
            titleDropMenu.dataArr = listDataSource
        }
    }
    var selectedCategoryIndex:Int! {
        didSet{
            titleDropMenu.selectedIdx = selectedCategoryIndex
            let model = listDataSource?[selectedCategoryIndex]
            titleView.setTitle(model?.cCategoryAlias, for: .normal)
            getLeftArrData(cGroupTypeNo: model?.cGroupTypeNo ?? "", index: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = titleView
        configureSearchAndShopCart()
        setupUI()
    }
    func setupUI() {
        _ = [leftTableView, rightGoodsView].map {
            self.view.addSubview($0)
        }
    }
    
    func configureSearchAndShopCart() {
        
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.setImage(UIImage(named: "category_search"), for: .normal)
        searchBtn.sizeToFit()
        searchBtn.frame.size = CGSize(width: 30, height: 30)
        searchBtn.addTarget(self, action: #selector(toSearchVCAction), for: .touchUpInside)
        
        let shopCart = UIButton.init(type: .custom)
        shopCart.setImage(UIImage(named: "hml_category_select"), for: .normal)
        shopCart.sizeToFit()
        shopCart.frame.size = CGSize(width: 30, height: 30)
        shopCart.addTarget(self, action: #selector(toShopCartVC), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shopCart),UIBarButtonItem.init(customView: searchBtn)]
    }
    
    func toSearchVCAction() {
        let vc = SearchVC()
        vc.title = "搜索"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toShopCartVC() {
        self.tabBarController?.selectedIndex = 2
    }
    
    // MARK: -- 获取左侧栏数据
    func getLeftArrData(cGroupTypeNo: String, index: Int) -> Void {
        
        self.leftArr = []
        self.rightArr = []
        
        self.leftTableView.reloadData(arr: self.leftArr)
        self.rightGoodsView.reloadData()
        
        let parameters = ["cParentNo":cGroupTypeNo,"cStoreNo":UserStoreManager.sharedManager.getStoreNo()]
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_left_Group", method: .post, parameters: parameters, success: { (result) in
            
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
           
                
                let data = json["dDate"].arrayObject
                
                self.leftArr = ClassifyTypeModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<ClassifyTypeModel>
                
                self.leftTableView.reloadData(arr: self.leftArr)
                
            }else {
                
            }
            
        }) { (error) in
            self.showHint(in: self.view, hint: "请求出错")
        }
        
    }
    func transformJson1(json:JSON) {
        
    }
    // MARK: -- 左侧栏点击事件
    func selectLeftTableView(model: ClassifyTypeModel, index: Int) -> Void{
        
        self.isLoad = false
        
        rightArr = []
        
        rightGoodsView.reloadData()
        
        currentLeftModel = model
        
        currentPage = 1
        
        getRightArrData(cGroupTypeNo: currentLeftModel!.cGroupTypeNo, pages: currentPage, index: index)
        
    }
    // MARK: -- 获取右侧栏数据
    func getRightArrData(cGroupTypeNo: String, pages: Int, index: Int?) -> Void {
        
        let parameters = ["cGroupTypeNo":cGroupTypeNo,"Number_of_pages":"\(pages)","cStoreNo":UserStoreManager.sharedManager.getStoreNo()]
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_right_goods", method: .post, parameters: parameters, success: { (result) in
            
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                
                self.transformJson2(json:json)
                
                if self.currentPage == 1 && index == 0 {
                    //数据返回成功 保存plist到沙盒中
                    savePlist(data: result as AnyObject,filename: "RightArrData.plist")
                }
                
            }else {
                if self.currentPage == 1 {
                    ///数据返回失败 从沙盒中获取
                    if getPlist(filename: "RightArrData.plist").state == true && index == 0 {
                        var resultDict = JSON.null
                        resultDict = JSON(getPlist(filename: "RightArrData.plist").plist)
                        if resultDict != JSON.null {
                            self.transformJson2(json: resultDict)
                        }
                    }
                }else{
                    self.isLoad = false
                    self.currentPage -= 1
                }
            }
            
        }) { (error) in
            if self.currentPage == 1 {
                ///数据返回失败 从沙盒中获取
                if getPlist(filename: "RightArrData.plist").state == true && index == 0 {
                    var resultDict = JSON.null
                    resultDict = JSON(getPlist(filename: "RightArrData.plist").plist)
                    if resultDict != JSON.null {
                        self.transformJson2(json: resultDict)
                    }
                }
            }
        }
        
    }
    func transformJson2(json:JSON) {
        let data = json["dDate"].arrayObject
        
        let modelArr = ShopCartStyleModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<ShopCartStyleModel>
        
        self.rightArr = self.rightArr + modelArr
        
        self.rightGoodsView.reloadData()
        self.isLoad = true
    }
}

extension CategoryDetailVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rightArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCategoryDetailVCCellID, for: indexPath) as! CategoryDetailCell
        let model = rightArr[indexPath.row]
        cell.shopCartModel = model
        
        cell.addGoodsToShopCartBlock = { (state,message) in
            self.showHint(in: self.view, hint: message)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rightArr[indexPath.row]
        
        let vc = GoodsDetailVC()
        vc.cGoodsNo = model.cGoodsNo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHGoodsCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (kScreenW*0.8-16)*0.467+16
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kImageHeight:CGFloat = (kScreenW*0.8-16)*0.467+16
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kImageHeight))
        let btn = UIButton.init(type: .custom)
        headerView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        btn.setImage(UIImage.init(named: "banner1"), for: .normal)
        btn.setImage(UIImage.init(named: "banner1"), for: .highlighted)
        return headerView

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if  rightGoodsView.cellForRow(at: IndexPath(row: rightArr.count - 3, section: 0)) != nil && self.isLoad {
            self.isLoad = false
            currentPage += 1
            getRightArrData(cGroupTypeNo: currentLeftModel!.cGroupTypeNo, pages: currentPage, index: nil)
        }
        
    }
    
    //滑动时不让点击botPageView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        leftTableView.setTableViewUserInterface(state: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        leftTableView.setTableViewUserInterface(state: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        leftTableView.setTableViewUserInterface(state: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        leftTableView.setTableViewUserInterface(state: true)
    }
    
}


extension CategoryDetailVC:DropMenuDelegate {
    func dropMeunDidSelectRow(row: Int) {
        selectGoodsType()
        self.selectedCategoryIndex = row
    }
}

class HL_RightBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.sizeToFit()
        
        var imageViewRect = imageView?.frame
        var titleRect = titleLabel!.frame
        
        titleRect.origin.x = (self.frame.width - titleRect.width)/2 - 5
        
        titleLabel?.textAlignment = .right
        titleLabel?.frame = titleRect
        imageViewRect?.origin.x = titleRect.maxX + 5
        imageView?.frame = imageViewRect!
        
    }
    
}



