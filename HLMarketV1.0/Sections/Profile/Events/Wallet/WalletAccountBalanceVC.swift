//
//  WalletAccountBalanceVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/13.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class WalletAccountBalanceVC: BaseViewController {

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var turnInBtn: UIButton!
    
    @IBOutlet weak var turnOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.turnInBtn.alpha = 0.0
        self.turnOutBtn.alpha = 0.0

        self.title = "余额"
        getData()
    }
    
    func getData() -> Void {
        
        self.priceLabel.text = "--"
        
        showHud(in: view)
        
        AlamofireNetWork.required(urlString: "/Simple_online/LastMoneyquery", method: .post, parameters: ["name":"{\"id\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\"}"], success: { (results) in
            
            self.hideHud()
            
            let json = JSON(results)
            
            self.priceLabel.text = String.init(format: "￥%0.2f", Float(Double(json["resultStatus"].float!)))
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "无网络服务")
        })
    }
    
    @IBAction func turnInAction(_ sender: Any) {
//        let vc = WalletAccountBalanceInOrOutVC()
//        vc.title = "转入"
//        vc.reloadPriceLabel = { [weak self] in
//            self?.getData()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func turnOutAction(_ sender: Any) {
//        let vc = WalletAccountBalanceInOrOutVC()
//        vc.title = "转出"
//        vc.reloadPriceLabel = { [weak self] in
//            self?.getData()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
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
