//
//  SearchVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kSearchTableViewCellID = "kSearchTableViewCellID"
private let kSearchCellCollectionViewCellID = "kSearchCellCollectionViewCellID"
private let kSearchCellCollectionViewCellMargin:CGFloat = 8


class SearchVC: AnimationVC, PageTitleViewDelegate {

    fileprivate lazy var tableView:UITableView = { [weak self] in
        let tableView = UITableView.init(frame: (self?.view.bounds)!, style: UITableViewStyle.plain)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        return tableView
    }()
    
    fileprivate var historyView: SearchHistoryView = {
        let view = SearchHistoryView(frame: CGRect(x: -kScreenW, y: 40, width: kScreenW, height: kScreenH-40-64))
        view.backgroundColor = UIColor.white
        view.alpha = 0.0
        return view
    }()
    
    fileprivate var keywordTextField = UITextField()
    
    fileprivate var botPageView: PageTitleView?
    
    fileprivate var colView: UICollectionView?
    
    fileprivate var dataArr = Array<ShopCartStyleModel>()
    
    fileprivate var currentType: Int = 0
    
    fileprivate var crrentSortType: Int = 0
    
    fileprivate var currentPage = 1
    
    fileprivate var isLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kSearchTableViewCellID)
        tableView.backgroundColor = UIColor.white
        
        self.view.addSubview(tableView)
        self.view.addSubview(historyView)
        
        historyView.selectBlock = { [weak self] searchStr in
            if searchStr != "" {
                self?.searchBtnAction1(str:searchStr)
            }else{
                self?.keywordTextField.resignFirstResponder()
            }
        }
        
        getSearchDate(type: currentType, fage: crrentSortType, pages: currentPage)
        
        //MARK: --- 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(afterChooseStoreAction), name: NotiNameOfAfterChooseStore, object: nil)
    }
    
    
    func afterChooseStoreAction() {
       getSearchDate(type: currentType, fage: crrentSortType, pages: currentPage)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: -- 获取数据
    func getSearchDate(type: Int, fage: Int, pages: Int) -> Void {
        
        let parameters = ["Sort_type":"\(type)","fage":"\(fage)","Number_of_pages":"\(pages)","cStoreNo":UserStoreManager.sharedManager.getStoreNo()]
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_Search_Goods", method: .post, parameters: parameters, success: { (result) in
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                let data = json["dDate"].arrayObject
                let modelArr = ShopCartStyleModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<ShopCartStyleModel>
                self.dataArr = self.dataArr + modelArr
                self.colView?.reloadData()
                self.isLoad = true
                
            }else {
                if self.currentPage == 1 {
                    self.showHint(in: self.view, hint: "数据为空")
                }else{
                    self.isLoad = false
                    self.currentPage -= 1
                }
            }
        }) { (error) in
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK: -- UITableViewDelegate, UITableViewDataSource
extension SearchVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSearchTableViewCellID, for: indexPath)
        
        
        //在cell上创建一个collectionView
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (kScreenW - 3 * kSearchCellCollectionViewCellMargin)/2.0
        let size = CGSize(width:itemWidth, height:itemWidth*1.5)
        layout.itemSize = size
        layout.minimumLineSpacing = kSearchCellCollectionViewCellMargin
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: kSearchCellCollectionViewCellMargin, left: kSearchCellCollectionViewCellMargin, bottom: kSearchCellCollectionViewCellMargin, right: kSearchCellCollectionViewCellMargin)
        
        colView = UICollectionView(frame: cell.bounds, collectionViewLayout:layout)
        
        
        colView!.delegate = self
        colView!.dataSource = self
        colView!.register(ShopCartStyleCell.self, forCellWithReuseIdentifier: kSearchCellCollectionViewCellID)
        colView!.backgroundColor = UIColor.white
        
        cell.addSubview(colView!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return kScreenH  - 70 - kStatusBarH - kNavigationBarH
    }
    
    //定义headerView的bounds和样式
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init()
        headerView.backgroundColor = UIColor.white
        
        let topBoxView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        topBoxView.backgroundColor = UIColor.init(gray: 252)
        keywordTextField = UITextField.init(frame: CGRect(x: 5, y: 5, width: kScreenW - 80, height: 30))
        keywordTextField.backgroundColor = UIColor.white
        keywordTextField.layer.borderColor = UIColor.init(gray: 221).cgColor
        keywordTextField.layer.borderWidth = 1
        keywordTextField.layer.cornerRadius = 5
        keywordTextField.layer.masksToBounds = true
        keywordTextField.delegate = self
        keywordTextField.clearButtonMode = .whileEditing
        
        
        
        let searchBtn = UIButton(type: UIButtonType.custom)
        searchBtn.frame = CGRect(x: kScreenW - 70, y: 5, width: 65, height: 30)
        searchBtn.setTitle("搜索", for: UIControlState.normal)
        searchBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        searchBtn.layer.backgroundColor = UIColor.appTextMainColor().cgColor
        searchBtn.layer.cornerRadius = 3
        searchBtn.layer.masksToBounds = true
        searchBtn.addTarget(self, action: #selector(searchBtnAction), for: .touchUpInside)
        
        
        topBoxView.addSubview(keywordTextField)
        topBoxView.addSubview(searchBtn)
        
        
        let botPageRect = CGRect(x: 0, y: 40, width: kScreenW, height: 30)
        botPageView = PageTitleView.init(frame: botPageRect, titles: ["默认", "价格", "销量", "浏览数"], isDoubleClick: true)
        botPageView?.delegate = self
        
        headerView.addSubview(topBoxView)
        headerView.addSubview(botPageView!)
        
        return headerView
    }
}

extension SearchVC: UITextFieldDelegate {
    // MARK: -- 搜索响应事件
    func searchBtnAction() -> Void {
        
        keywordTextField.resignFirstResponder()
        
        if keywordTextField.text?.characters.count == 0 {
            showHint(in: view, hint: "请输入要搜索的内容")
            return
        }
        
        saveSearchData(str: keywordTextField.text!)
        
        let vc = SearchVC1()
        vc.searchStr = keywordTextField.text!
        vc.navigationItem.title = "相关搜索"
        navigationController?.pushViewController(vc, animated: true)
        
        keywordTextField.text = ""
       
    }
    // MARK: -- 点击历史记录搜索
    func searchBtnAction1(str: String) -> Void {
        
        keywordTextField.text = ""
        keywordTextField.resignFirstResponder()
        
        let vc = SearchVC1()
        vc.searchStr = str
        vc.navigationItem.title = "相关搜索"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    // MARK: -- 保存搜索历史
    func saveSearchData(str: String) -> Void {
        
        let rect = str.boundingRect(with: CGSize.init(width: 0, height: Int.max), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:font(14)], context: nil)
        var width = rect.size.width + 10
        width = width < WID*3 ? WID*3 : width
        width = width > WID*8 ? WID*8 : width
        
        FMDBManager.share().executeDBSQLArr(["delete from \(SearchHistoryDBName) where name = '\(str)'","insert into \(SearchHistoryDBName) (name,width,saveTime) values('\(str)','\(width)','\(getDate())')"])
    }
    // MARK: -- PageTitleViewDelegate
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int) {
        //"默认"的排序方式只能为"0"
        if currentType != 0 && currentType == index && crrentSortType == 0 {
            crrentSortType = 1
        }else{
            crrentSortType = 0
        }
        
        isLoad = false
        
        dataArr = []
        
        colView?.reloadData()
        
        currentPage = 1
        
        currentType = index
        
        getSearchDate(type: currentType, fage: crrentSortType, pages: currentPage)
    }
    // MARK: -- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if keywordTextField.text?.characters.count != 0 {
            searchBtnAction()
        }
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        historyView.show()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        historyView.hid()
    }
    
}

// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension SearchVC:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ShopCartStyleCell = collectionView.dequeueReusableCell(withReuseIdentifier: kSearchCellCollectionViewCellID, for: indexPath) as! ShopCartStyleCell
        
        cell.backgroundColor = UIColor.white
        
        //cell.layer.borderColor = UIColor.init(gray: 246).cgColor
        //cell.layer.borderWidth = 1
        //cell.layer.cornerRadius = 6
        //cell.layer.masksToBounds = true
        cell.layer.shadowColor  = UIColor.colorFromHex(0xcdcdcd).cgColor
        cell.layer.shadowRadius = 3
        cell.layer.contentsScale = UIScreen.main.scale;
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        //设置缓存
        cell.layer.shouldRasterize = true
        //设置抗锯齿边缘
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        let model = dataArr[indexPath.row]
        cell.shopCartModel = model
        
        cell.addGoodsToShopCartBlock = { (state,message) in
            self.showHint(in: self.view, hint: message)
        }
        
        //进行动画操作的时候, 必须要知道当前图片所在的视图
//        print("\(indexPath.row)-------")
        
        
        cell.addProductClick = {(imageView) -> () in
            self.addProductAnimation(imageView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        
        let vc = GoodsDetailVC()
        vc.cGoodsNo = model.cGoodsNo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.6) {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if  colView?.cellForItem(at: IndexPath(row: dataArr.count - 3, section: 0)) != nil && self.isLoad {
            self.isLoad = false
            currentPage += 1
            getSearchDate(type: currentType, fage: crrentSortType, pages: currentPage)
        }
    }
    //滑动时不让点击botPageView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        botPageView?.setLabelUserInterface(state: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        botPageView?.setLabelUserInterface(state: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        botPageView?.setLabelUserInterface(state: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataArr.count == 0 {
            getSearchDate(type: currentType, fage: crrentSortType, pages: currentPage)
        }
    }
    
}




















