//
//  OrderPaySuccessVC.swift
//  
//
//  Created by 彭仁帅 on 2017/3/25.
//
//

import UIKit

class OrderPaySuccessVC: BaseViewController {
    
    var orderPrice = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "支付完成"
        
        createUI()
    }
    
    func createUI() -> Void {
        
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backBtn.setImage(#imageLiteral(resourceName: "差号"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "hlm_paysuccess"))
        view.addSubview(imageView)
        
        let label = UILabel()
        label.text = "支付完成"
        label.font = font(20)
        label.textAlignment = .center
        label.textColor = UIColor.appTextMainColor()
        view.addSubview(label)
        
        let label1 = UILabel()
        label1.text = orderPrice + "元"
        label1.font = font(25)
        label1.textAlignment = .center
        view.addSubview(label1)

        let btn = UIButton(type: .custom)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.appTextMainColor()
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        view.addSubview(btn)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.width.equalToSuperview().dividedBy(8)
            make.height.equalTo(imageView.snp.width)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        label1.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(label1.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func backBtnAction() -> Void {
       _ = self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: -- 禁用/开启边缘右滑
extension OrderPaySuccessVC {
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
}
