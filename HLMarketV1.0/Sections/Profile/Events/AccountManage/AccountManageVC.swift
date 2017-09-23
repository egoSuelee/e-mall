//
//  AccountManageVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 09/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit


private let kAccountManageTableCellID = "kAccountManageTableCell"
class AccountManageVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.white
        self.configureTableView()
        
        self.navigationItem.title = "设置"
    }

    func configureTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.init(gray: 252)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0.5))
        view.backgroundColor = UIColor.init(gray:215)
        tableView.tableFooterView = view
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kAccountManageTableCellID)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kAccountManageTableCellID, for: indexPath)

        let textArray = [("hlm_pay_pwd", "头像"), ("hlm_bind_phone", "昵称"), ("hlm_address", "邮箱"), ("hlm_upgrad", "手机号码")]
        
        cell.textLabel?.text  = textArray[indexPath.row].1
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
