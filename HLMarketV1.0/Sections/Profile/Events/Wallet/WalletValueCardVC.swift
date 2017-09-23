//
//  WalletValueCardVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/13.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

let WalletTCellHei = kScreenH/4 + 10

class WalletValueCardVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 1, width: kScreenW, height: kScreenH))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 1, width: kScreenW, height: kScreenH-64-2), style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var dataArr = [[String:Any]]()
    
    lazy var btnStateArr = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "储值卡"
        
        self.view.backgroundColor = UIColor(red: 0.0235, green: 0.8567, blue: 0.776, alpha: 1)
        
        setRightBarButtonItem()
        
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self;
        
        getCartData()
    }
    // MARK: -- 添加储值卡
    func setRightBarButtonItem() -> Void {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btn.setBackgroundImage(#imageLiteral(resourceName: "hlm_add_new_address"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "hlm_add_new_address"), for: .highlighted)
        btn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func rightBtnAction() -> Void {
        let vc = WalletAddValueCardVC()
        vc.reloadData = { [weak self] in
            self?.getCartData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: -- tableView代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WalletValueCardTCell? = tableView.dequeueReusableCell(withIdentifier: "cellID") as? WalletValueCardTCell
        if cell == nil {
            cell = WalletValueCardTCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.code = "\(dataArr[indexPath.row]["ID_Card"]!)"
        cell?.money = "\(dataArr[indexPath.row]["money"]!)"
        cell?.btnState = self.btnStateArr[indexPath.row]
        cell?.barMoneyIsHideBtn.addTarget(self, action: #selector(cellBtnAction(btn:)), for: .touchUpInside)
        cell?.barMoneyIsHideBtn.tag = indexPath.row
        cell?.selectionStyle = .none
        return cell!
    }
    
    func cellBtnAction(btn: UIButton) -> Void {
        let cell: WalletValueCardTCell = tableView.cellForRow(at: IndexPath(row: btn.tag, section: 0)) as! WalletValueCardTCell
        cell.btnState = !cell.btnState!
        self.btnStateArr.replaceSubrange(btn.tag..<btn.tag+1, with: [cell.btnState!])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WalletTCellHei
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK: -- 请求储值卡数据
    func getCartData() -> Void {
        
        dataArr = []
        
        tableView.reloadData() 
        
        AlamofireNetWork.required(urlString: "/Simple_online/Select_UserMoney_Car", method: .post, parameters: ["data":"{\"Buyer_id\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\"}"], success: { (results) in
            
            let json = JSON(results)
            
            if json["resultStatus"] == 1 {
                self.hideHud()
                self.dataArr = json["data"].arrayObject as! [[String : Any]]
                self.btnStateArr = Array(repeating: false, count: self.dataArr.count)
                self.tableView.reloadData()
            }
            
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
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
