//
//  MemberIntegralVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/28.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kMemberIntegralVCCellID = "kMemberIntegralVCCellID"
private let kMemberIntegralVCHeaderID = "kMemberIntegralVCHeaderID"

class MemberIntegralVC: BaseViewController {
    
    lazy var topView: MemberIntegralTopView = {
        let view = MemberIntegralTopView()
        view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: (kScreenH-64)/3.5 + 30)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate lazy var tableView: UITableView =  { [weak self] in
        
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 64-10)
        
        let tableView = UITableView(frame: rect, style: UITableViewStyle.plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MemberIntegralTCell", bundle: nil), forCellReuseIdentifier: kMemberIntegralVCCellID)
        tableView.register(UINib.init(nibName: "MemberIntegralHeaderTView", bundle: nil), forHeaderFooterViewReuseIdentifier: kMemberIntegralVCHeaderID)
        tableView.backgroundColor = UIColor(red:0.957, green:0.957, blue:0.957, alpha:1.000)
        tableView.bounces = false
        tableView.tableHeaderView = self?.topView
        return tableView
        }()
    
    fileprivate var dataArr = [[String:Any]]()
    fileprivate var lastModel: MemberIntegralModel!
    fileprivate var page: Int = 1
    fileprivate var isLoad = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的积分"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.tableView)
        self.topView.integral = "---"
        
        getData(page)
        
        
    }
    
    // MARK: -- 获取数据
    func getData(_ page: Int) -> Void {
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_VipMessage", method: .post, parameters: ["Tel":UserAuthManager.sharedManager.getUserModel()!.UserNo,"Number_of_pages":"\(page)"], success: { (result) in
            
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                
                self.topView.integral = (json["fCurValue"].string ?? "0").intString()
                
                let data = json["dDate"].arrayObject
                
                let modelArr = MemberIntegralModel.mj_objectArray(withKeyValuesArray: data).copy() as! Array<MemberIntegralModel>
                
                var lastItemDate: MemberIntegralDateModel?
                var lastMonthArr: [MemberIntegralModel]!
                var lastMonthScore: Int = 0
                
                if page == 1 {
                    lastItemDate = nil
                    lastMonthArr = [MemberIntegralModel]()
                    lastMonthScore = 0
                }else{
                    lastItemDate = self.lastModel.date
                    lastMonthArr = self.dataArr[self.dataArr.count-1]["arr"] as! [MemberIntegralModel]
                    lastMonthScore = self.dataArr[self.dataArr.count-1]["score"] as! Int
                    self.dataArr.removeLast()
                }

                for (index,model) in modelArr.enumerated() {
                    if model.date.isSameMonth(item: lastItemDate) {
                        lastMonthArr.append(model)
                        lastMonthScore += Int(Double(model.fVipScore_cur) ?? 0)
                        if index == modelArr.count-1 {
                            self.lastModel = model
                            self.dataArr.append(["score":lastMonthScore,"arr":lastMonthArr])
                        }
                    }else{
                        lastItemDate = model.date
                        lastMonthScore += Int(Double(model.fVipScore_cur) ?? 0)
                        if index > 1 || page > 1 {
                            self.dataArr.append(["score":lastMonthScore,"arr":lastMonthArr])
                        }
                        lastMonthArr = [MemberIntegralModel]()
                        lastMonthArr.append(model)
                    }
                }
                self.isLoad = true
                self.tableView.reloadData()
                
            }else {
                self.isLoad = false
                if page == 1 {
                    self.showHint(in: self.view, hint: "用户暂无积分相关信息")
                }else{
                    self.page -= 1
                }
                
            }
            
        }) { (error) in
            print(error)
        }
    }
}

// MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension MemberIntegralVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count == 0 ? 0 : dataArr.count+1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0 else {
            return 1
        }
        let arr = dataArr[section-1]["arr"] as! [MemberIntegralModel]
        return arr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kMemberIntegralVCCellID) as! MemberIntegralTCell
        
        cell.backgroundColor = UIColor(red:0.957, green:0.957, blue:0.957, alpha:1.000)
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            cell.label1.text = "积分记录"
            cell.label2.text = ""
        }else{
            let arr = dataArr[indexPath.section-1]["arr"] as! [MemberIntegralModel]
            let model = arr[indexPath.row]
            cell.label1.text = model.date.time
            cell.label2.text = "+" + model.fVipScore_cur.intString()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else {
            return 0.00001
        }
        return 47
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else {
            return nil
        }
        let arr = dataArr[section-1]["arr"] as! [MemberIntegralModel]
        let model = arr[0]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kMemberIntegralVCHeaderID) as! MemberIntegralHeaderTView
        headerView.label1.text = model.date.getMonthTitle()
        headerView.label2.text = "总计: \(dataArr[section-1]["score"] as! Int)"
        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.dataArr.count > 0 else {
            return
        }
        
        let arr = dataArr[self.dataArr.count-1]["arr"] as! [MemberIntegralModel]
        
        if  tableView.cellForRow(at: IndexPath(row: arr.count - 1, section: self.dataArr.count)) != nil && self.isLoad {
            self.isLoad = false
            page += 1
            getData(page)
        }
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.transform = CGAffineTransform(translationX: 0, y: 30)
//        UIView.animate(withDuration: 0.6) {
//            cell.transform = CGAffineTransform(translationX: 0, y: 0)
//        }
//    }
    
}



