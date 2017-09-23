//
//  GuideVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class GuideVC: BaseViewController, UIScrollViewDelegate {
    
    var scrollerView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollerView = UIScrollView(frame: view.frame)
        scrollerView.delegate = self
        scrollerView.isPagingEnabled = true
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.bounces = false
        view.addSubview(scrollerView)
        
        for i in 0..<3{
            let imageView = UIImageView(image: UIImage.init(named: "启动页\(i+1)"))
            imageView.frame = CGRect(x: kScreenW*CGFloat(i), y: 0, width: kScreenW, height: kScreenH)
            scrollerView.addSubview(imageView)
        }
        
        scrollerView.contentSize = CGSize(width: kScreenW*CGFloat(3), height: kScreenH)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: kScreenW*(CGFloat(3))-50, y: kScreenH*0.91, width: 50, height: 50)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        scrollerView.addSubview(btn)
    }
    
    func btnAction() -> Void {
        let storeVC = ChooseStoreVC()
        storeVC.type = 2
        storeVC.type2Action = {
            let vc = TabBarController.shareTabBarController
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        self.present(storeVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
