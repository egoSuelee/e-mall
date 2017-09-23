//
//  ServiceAgreementVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/9/2.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class ServiceAgreementVC: BaseViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "乐家优鲜服务协议"
        
        let baseURL  = URL.init(fileURLWithPath: Bundle.main.bundlePath)
        let htmlPath = Bundle.main.path(forResource: "service", ofType: "html")
        let htmlCont = try! String.init(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
        self.webView.loadHTMLString(htmlCont, baseURL: baseURL)
        self.webView.backgroundColor = UIColor.white
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
