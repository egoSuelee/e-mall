//
//  CouponVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 09/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class CouponVC: BaseViewController {

    
    lazy var pageTitleView:PageTitleView = { () -> PageTitleView in
        let pageTitleRect = CGRect(x: 0, y: 0, width: kScreenW, height: 36)
        let pageTitleView = PageTitleView.init(frame: pageTitleRect, titles: ["未使用", "已使用"])
        return pageTitleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的优惠券"
        
        self.view.backgroundColor = UIColor.white
     
        
        self.view.addSubview(pageTitleView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension CouponVC:PageTitleViewDelegate {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int) {
//        print("Click\(index)")
    }
}
