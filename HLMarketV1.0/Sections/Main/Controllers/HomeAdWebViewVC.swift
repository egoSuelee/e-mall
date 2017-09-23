//
//  HomeAdWebViewVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/7/31.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HomeAdWebViewVC: BaseViewController {
    
    fileprivate lazy var webView: UIWebView = { [weak self] in
        let webView = UIWebView.init(frame: CGRect(x: 0, y: 20, width: kScreenW, height: kScreenH-20))
        return webView
        }()
    
    fileprivate lazy var webViewBackBtn: UIButton = { [weak self] in
        let backBtn = UIButton.init(type: UIButtonType.custom)
        backBtn.frame = CGRect(x: 10, y: 30, width: 33, height: 33)
        backBtn.setImage(#imageLiteral(resourceName: "hlm_back_icon"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: UIControlEvents.touchUpInside)
        backBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        return backBtn
        }()
    
    var urlStr: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let request = URLRequest.init(url: URL.init(string: urlStr)!)
        webView.loadRequest(request)
        self.view.addSubview(webView)
        self.view.addSubview(webViewBackBtn)

    }
    
    func backBtnAction() {
        self.dismiss(animated: true, completion: nil)
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
