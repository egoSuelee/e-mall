//
//  WalletRecordVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class WalletRecordVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,PageTitleViewDelegate {
    
    lazy var pageTitleView:PageTitleView = { () -> PageTitleView in
        let pageTitleRect = CGRect(x: 0, y: 0, width: kScreenW, height: 46)
        let pageTitleView = PageTitleView.init(frame: pageTitleRect, titles: ["支付记录", "转账记录"])
//        , "储值卡记录"
        return pageTitleView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 46, width: kScreenW, height: kScreenH-64-46), style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var dataArr = [[String:Any]]()
    
    lazy var type: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "账单"
        
        self.view.addSubview(pageTitleView)
        pageTitleView.delegate = self
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WalletRecordTCell", bundle: nil), forCellReuseIdentifier: "cellID")
        
        self.getRecordData(fage: 1)
    }
    
    // MARK: -- PageTitleViewDelegate
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int) {
//        self.type = index+1
        
        switch index {
        case 0:
            self.type = 1
        default:
            self.type = 3
        }
        
        self.getRecordData(fage: self.type)
    }
    
    // MARK: -- 请求记录数据
    func getRecordData(fage: Int) -> Void {
        
        dataArr = []
        
        tableView.reloadData()
        
        showHud(in: self.view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_wallet_log", method: .post, parameters: ["Buyer_id":"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)","Number_of_pages":"1","fage":"\(fage)"], success: { (results) in
            
            let json = JSON(results)
            
            if json["resultStatus"] == 1 {
                self.hideHud()
                self.dataArr = json["data"].arrayObject as! [[String : Any]]
                self.tableView.reloadData()
            }else{
                self.hideHud()
            }
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
    }
    
    // MARK: -- tableView代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WalletRecordTCell? = tableView.dequeueReusableCell(withIdentifier: "cellID") as? WalletRecordTCell
        if cell == nil {
            cell = WalletRecordTCell(style: .default, reuseIdentifier: "cellID")
        }
        
        let dic = dataArr[indexPath.row]
        
        switch self.type {
        case 1:
            cell?.dataDic = ["date":"\(dic["T_paytime"]!)","money":"\(dic["fLastMoney"]!)".cgFloatString(),"moneyState":"0","id":"\(dic["cStoreName"]!)"]
        case 2:
            cell?.dataDic = ["date":"\(dic["date_time"]!)","money":"\(dic["Move_money"]!)".cgFloatString(),"moneyState":"\(dic["Money_Into"]!)","id":"\(dic["Buyer_id"]!)"]
        case 3:
            let state = "\(dic["Out_ID"]!)" == UserAuthManager.sharedManager.getUserModel()!.UserNo
            cell?.dataDic = ["date":"\(dic["WTransfer_Datetime"]!)","money":"\(dic["WTransfer_Money"]!)".cgFloatString(),"moneyState":state ? "0":"1","id":"\(dic["In_Name"]!)"]
        default:
            break
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
