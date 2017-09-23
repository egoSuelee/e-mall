//
//  ProfileHeaderView.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 09/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileHeaderView: UIView {

    var profileHeaderViewCallBack:(( _ type: Int)->Void)?
    
    lazy var bcImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "背景")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0), resizingMode: UIImageResizingMode.stretch)
        return imageView
    }()
    
    lazy var iconImageView:UIImageView = {
        let imageView = UIImageView.init()
        
        if let userIcon = UserAuthManager.sharedManager.getUserModel()?.UserIcon {
            imageView.kf.setImage(with: URL.init(string: DefaultURL + "/Simple_online/" + userIcon) as Resource?, placeholder: UIImage.init(named: "头像"),options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(1)), KingfisherOptionsInfoItem.forceRefresh], progressBlock: nil, completionHandler: nil)
        } else {
            imageView.image = UIImage.init(named: "头像")
        }
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var iconBtn:UIButton = { [weak self] in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setImage(UIImage.init(named:"hlm_upload_pic"), for: .normal)
        btn.addTarget(self, action: #selector(iconBtnAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var editLoginBtn:UIButton = { [weak self] in
        let btn = UIButton.init(type: UIButtonType.custom)
    
        btn.backgroundColor = UIColor.clear
        btn.layer.borderWidth = _1pxWidth
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setTitle("登录/注册", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(loginAction), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    lazy var scanBtn:UIButton = { [weak self] in
        let btn = HLP_MiniImageSizeBtn.image(scale: 0.5)
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.setImage(UIImage(named: "扫一扫"), for: .normal)
        btn.frame.size = CGSize(width: 30, height: 30)
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        btn.addTarget(self, action: #selector(scanBtnAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var scanLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.text = "扫一扫"
        label.textAlignment = .center
        return label
    }()
    
//    lazy var barBtn:UIButton = { [weak self] in
//        let btn = HLP_MiniImageSizeBtn.image(scale: 0.5)
//        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
//        btn.layer.cornerRadius = 25
//        btn.layer.masksToBounds = true
//        btn.setImage(UIImage(named: "二维码"), for: .normal)
//        btn.frame.size = CGSize(width: 30, height: 30)
//        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//        btn.addTarget(self, action: #selector(barBtnAction), for: .touchUpInside)
//        return btn
//    }()
//
//    lazy var barLabel:UILabel = {
//        let label = UILabel.init()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = UIColor.white
//        label.text = "付款码"
//        label.textAlignment = .center
//        return label
//    }()
    
    func barBtnAction() {
        profileHeaderViewCallBack!(4)
    }
    
    func scanBtnAction() {
        profileHeaderViewCallBack!(3)
    }
    
    func iconBtnAction() {
        profileHeaderViewCallBack!(2)
    }
    
    func loginAction() {
        profileHeaderViewCallBack!(1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bcImageView)

        if UserAuthManager.sharedManager.isUserLogin() {
            self.addSubview(iconImageView)
            self.addSubview(nameLabel)
            self.addSubview(iconBtn)
            self.addSubview(scanBtn)
//            self.addSubview(barBtn)
            self.addSubview(scanLabel)
//            self.addSubview(barLabel)
            let model = UserAuthManager.sharedManager.getUserModel()
            if model?.UserNo == "" {
                nameLabel.text = "暂无昵称"
            } else {
                nameLabel.text = model!.UserNo
            }
        } else {
            self.addSubview(editLoginBtn)
        }
    }
    
    override func layoutSubviews() {
        
        bcImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if UserAuthManager.sharedManager.isUserLogin() {
            iconImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(70)
                make.left.equalToSuperview().offset(WID/2)
                make.centerY.equalToSuperview().offset(15)
            }
            iconBtn.snp.makeConstraints { (make) in
                make.bottom.equalTo(iconImageView.snp.bottom).offset(-5)
                make.right.equalTo(iconImageView.snp.right).offset(-5)
                make.height.width.equalTo(20)
            }
//            barBtn.snp.makeConstraints { (make) in
//                make.width.height.equalTo(50)
//                make.right.equalToSuperview().offset(-WID/2)
//                make.centerY.equalTo(iconImageView.snp.centerY).offset(-10)
//            }
//            barLabel.snp.makeConstraints { (make) in
//                make.left.right.equalTo(barBtn)
//                make.top.equalTo(barBtn.snp.bottom)
//                make.height.equalTo(25)
//            }
//            scanBtn.snp.makeConstraints { (make) in
//                make.width.height.equalTo(barBtn.snp.width)
//                make.right.equalTo(barBtn.snp.left).offset(-WID/2)
//                make.centerY.equalTo(iconImageView.snp.centerY).offset(-10)
//            }
            scanBtn.snp.makeConstraints { (make) in
                make.width.height.equalTo(50)
                make.right.equalToSuperview().offset(-WID/2)
                make.centerY.equalTo(iconImageView.snp.centerY).offset(-10)
            }
            scanLabel.snp.makeConstraints { (make) in
                make.left.right.equalTo(scanBtn)
                make.top.equalTo(scanBtn.snp.bottom)
                make.height.equalTo(25)
            }
            nameLabel.snp.makeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(WID/2)
                make.right.equalTo(scanBtn.snp.left).offset(-5)
                make.height.equalTo(44)
                make.centerY.equalTo(iconImageView.snp.centerY)
            }
        } else {
            editLoginBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview().offset(15)
                make.centerX.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(30)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
