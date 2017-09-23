
//
//  NotificationVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/6/6.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationVC: BaseViewController {
    
    fileprivate var dataArr = [[String:String]]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-64), style: UITableViewStyle.plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: "NotificationTCell", bundle: nil), forCellReuseIdentifier: "CellID")
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "公告"
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.getTongZhi()
        
        //获取通知  刷新公告
        NotificationCenter.default.addObserver(self, selector: #selector(getTongZhi), name: NSNotification.Name(rawValue: "ReloadNotifitionData"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReloadNotifitionData"), object: nil)
    }
    
    func getTongZhi() -> Void {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotifitionData1"), object: nil)
        
        self.dataArr = []
        self.tableView.reloadData()
        
        AlamofireNetWork.required(urlString: "/Simple_online/Announcement", method: .post, parameters: ["fage":"1"], success: { (result) in
            
            let json = JSON(result)
            if json["resultStatus"] == "1" {
                guard let arr = json["dDate"].arrayObject else{
                    self.showHint(in: self.view, hint: "暂无公告")
                    return
                }
                self.dataArr = arr as! [[String : String]]
                self.tableView.reloadData()
            }
            
        }) { (error) in
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationTCell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! NotificationTCell
        let dic = dataArr[indexPath.row]
        cell.titleLabel.text = dic["title"]
        cell.timeLabel.text = dic["dDate"]
        cell.contentLabel.text = dic["contentdetails"]
        
        if indexPath.row == 0 {
            cell.strLabel.text = "有新通知啦!"
        }else {
            cell.strLabel.text = "通知!"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dic = dataArr[indexPath.row]
        let content = dic["contentdetails"]
        var cellHei = content!.boundingRect(with: CGSize.init(width: kScreenW-140, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context: nil).size.height + 105
        
        cellHei = cellHei <= 120 ? 120 : cellHei
        
        return cellHei
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
}
