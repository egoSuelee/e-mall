//
//  ProfileVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

private let kProfileTableCellID = "kProfileTableCellID"
private let kProfileInfoLabelCellID = "kProfileInfoLabelCell"
private let kProfileCollectionCellID = "kProfileCollectionCell"

class ProfileVC: BaseViewController {
    
    var profileHeaderView:ProfileHeaderView?
    
    lazy var profileTableView:UITableView = {[weak self] in
        let tableRect = CGRect(x: 0, y: -20, width: kScreenW, height: kScreenH - kTabBarH + 20)
        let tableview = UITableView.init(frame: tableRect, style: UITableViewStyle.grouped)
        
        tableview.showsVerticalScrollIndicator = false
        tableview.backgroundColor = UIColor.white
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.delegate = self
        tableview.dataSource  = self
        
        //MARK: 各种注册cell 
        /*
         该页面一共有三种cell, 两种headerView
        */
        tableview.register(ProfileTableCell.self, forCellReuseIdentifier:kProfileTableCellID)
        tableview.register(ProfileInfoLabelCell.self, forCellReuseIdentifier:kProfileInfoLabelCellID)
        tableview.register(ProfileCollectionCell.self, forCellReuseIdentifier: kProfileCollectionCellID)
        
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(profileTableView)
        NotificationCenter.default.addObserver(self,selector:#selector(successLogin(notification:)), name: NSNotification.Name(rawValue: userLoginOutActionNoficition), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(successLogin(notification:)), name: NSNotification.Name(rawValue: goodsCollectCountChanged), object: nil)
        
        UserDefaults.standard.set(4, forKey: HOME_CHILDVCS)
    }

    func successLogin(notification:NSNotification) {
       self.profileTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
}

// ------------------- Delegate ----------------------------//

extension ProfileVC:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kProfileCollectionCellID) as! ProfileCollectionCell
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kProfileTableCellID) as! ProfileTableCell
            let listInfoArray = [("钱包", "我的钱包"),
                                 ("会员", "钱包充值")]
//            ("积分", "我的积分")
            cell.imageView?.image = UIImage.init(named: listInfoArray[indexPath.row].0)
            cell.textLabel?.text = listInfoArray[indexPath.row].1
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            //cell.selectionStyle = .none
            
            switch indexPath.row {
            case 1:
                cell.sepLineLabel.frame = CGRect.zero
            default:
                cell.sepLineLabel.frame = CGRect(x: 20, y: cell.contentView.frame.size.height-_1pxWidth, width: kScreenW-40, height: _1pxWidth)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kProfileTableCellID) as! ProfileTableCell
            let listInfoArray = [("地址", "地址管理"),
                                 ("修改密码", "修改支付密码"),
                                 ("意见","意见反馈"),
                                 ("协议","服务协议"),
                                 ("退出登录", "退出登录")]
//            ("设置","设置")
            cell.imageView?.image = UIImage.init(named: listInfoArray[indexPath.row].0)
            cell.textLabel?.text = listInfoArray[indexPath.row].1
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.sepLineLabel.frame = CGRect(x: 20, y: cell.contentView.frame.size.height-_1pxWidth, width: kScreenW-40, height: _1pxWidth)
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            //cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 44
        }
    }
    
    //Mark: 点击Cell进行的交互
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section != 0 else {
            return
        }
        
        guard UserAuthManager.sharedManager.isUserLogin() else {
            showHint(in: self.view, hint: "您还未登录")
            return
        }
        
        switch (indexPath.section,indexPath.row) {
        case (1,0):
            //MARK: -- 钱包页面
            let vc = WalletHomeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case (1,1):
            //MARK: -- 钱包充值页面
            let vc = WalletRechargeVC()
            self.navigationController?.pushViewController(vc, animated: true)
//        case (1,2):
//            //MARK: -- 我的积分页面
//            let vc = MemberIntegralVC()
//            self.navigationController?.pushViewController(vc, animated: true)
        case (2,0):
            //MARK: -- 地址管理页面
            let addressVC = AddressManageVC()
            self.navigationController?.pushViewController(addressVC, animated: true)
        case (2,1):
            // MARK: -- 修改支付密码
            let vc = WalletChangePassword()
            self.navigationController?.pushViewController(vc, animated: true)
//        case (2,2):
//            // MARK: -- 设置
//            let vc = WalletChangePassword()
//            self.navigationController?.pushViewController(vc, animated: true)
//            break
        case (2,2):
            // MARK: -- 意见反馈
            let suggestVC = SuggestionVC()
            self.navigationController?.pushViewController(suggestVC, animated: true)
        case (2,3):
            // MARK: -- 服务协议
            let serviceVC = ServiceAgreementVC.init(nibName: "ServiceAgreementVC", bundle: nil)
            self.navigationController?.pushViewController(serviceVC, animated: true)
        case (2,4):
            //MARK: --- 用户退出登录
            let alertVC = UIAlertController.init(title: "是否确定退出登录", message: nil, preferredStyle: .alert)

            let confirmAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction:UIAlertAction) in
                self.profileTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                UserAuthManager.sharedManager.cleanUserInfo()
                if UserAuthManager.sharedManager.getUserModel() == nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: userLoginOutActionNoficition), object: self,userInfo: ["UserActionType":HLUserAction.logOut])
                }
                
            }
            let  cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            
            alertVC.addAction(confirmAction)
            alertVC.addAction(cancelAction)
            
            self.present(alertVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
  
    //-------------------- 定义headerView的大小和样式
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 160
        default:
            return 0.00001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // MARK: - 登录、上传头像、扫一扫、付款码
        switch section {
        case 0:
            let headerRect = CGRect(x: 0, y: 0, width: kScreenW, height: 160)
            let headerView = ProfileHeaderView.init(frame: headerRect)
            headerView.profileHeaderViewCallBack = {[weak self] type in
                switch type {
                case 1:
                    let registerVC = LoginViewController()
                    self?.navigationController?.pushViewController(registerVC, animated: true)
                case 2:
                    self?.uploadPicAction()
                case 3:
                    let scanVC = ScanQRCodeVC()
                    self?.navigationController?.pushViewController(scanVC, animated: true)
//                case 4:
//                    let vc = XSVirtualMemberCardViewController()
//                    vc.getCodeBlock = {[weak self] in
//                        self!.getCode()
//                    }
//                    vc.loadScanDataFromServiceBlock = {[weak self] code in
//                        self!.loadScanDataFromService(code: code!)
//                    }
//                    self?.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
            }
            self.profileHeaderView = headerView
            return headerView
        default:
            return nil
        }
    }
    
    
    //--------------------  定义 footerView的大小和样式
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 0.00001
        default:
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 2:
            return nil
        default:
            let footerView = UIView()
            footerView.backgroundColor = UIColor.gray.withAlphaComponent(0.07)
            return footerView
        }
    }
    
}

//MARK: --- "全部订单","待付款", "待发货", "待取货", "待收货", "已完成"
extension ProfileVC:ProfileCollectionCellDelegate {
    func profileCollectionDidSelected(_ index: Int) {
        
        guard UserAuthManager.sharedManager.isUserLogin() else {
            showHint(in: self.view, hint: "您还未登录")
            return
        }
        
        //let titleArr = ["全部订单","待付款", "待发货", "待取货", "待收货", "已完成"]
        let vc = PF_AllOrdersVC()
        switch index {
        case 0,1:
            vc.orderMix = PFOrderMix.init(type: .Dispatch, state: .unpay)
        case 2:
            vc.orderMix = PFOrderMix.init(type: .Dispatch, state: .unpost)
        case 3:
            vc.orderMix = PFOrderMix.init(type: .PickUp, state: .untake)
        case 4:
            vc.orderMix = PFOrderMix.init(type: .Dispatch, state: .unreceive)
        default:
            vc.orderMix = PFOrderMix.init(type: .Dispatch, state: .completed)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 付款码网络数据请求
extension ProfileVC {
    func getCode() -> Void{
        
        let parameter = ["name":"{\"UserId\":\"\(UserAuthManager.sharedManager.getUserModel()!.UserNo)\",\"app_system\":\"\(UIDevice.current.systemName)\",\"app_version\":\"\(UIDevice.current.systemVersion)\",\"number\":\"null\"}"]
        
        AlamofireNetWork.required(urlString: "/Simple_online/GetCode", method: .post, parameters: parameter, success: { (results) in
            
            let json = JSON(results)
            
            if json["resultStatus"] == 1 {
                let code = json["paycode"].int!
                let dic = ["state":"1","code":"\(code)"]
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RoloadWalletCodeNotification"), object: nil, userInfo: dic)
            }else{
                let dic = ["state":"0","data":"请求出错"]
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RoloadWalletCodeNotification"), object: nil, userInfo: dic)
            }
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "")
            let dic = ["state":"0","data":"无网络服务"]
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RoloadWalletCodeNotification"), object: nil, userInfo: dic)
        })
    }
    
    func loadScanDataFromService(code: String) -> Void{
        
        let parameter = ["data":"{\"paycode\":\"\(code)\"}"]
        
        AlamofireNetWork.required(urlString: "/Simple_online/WalletYesOrNo", method: .post, parameters: parameter, success: { (results) in
            
            let json = JSON(results)
            
            let code = json["PayCode"].int ?? 0
            let dic = ["state":"1","code":"\(code)"]
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "LoadScanDataFromServiceNotification"), object: nil, userInfo: dic)
            
        }, failure: { (error) in
            self.showHint(in: self.view, hint: "")
            let dic = ["state":"0","data":"无网络服务"]
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "LoadScanDataFromServiceNotification"), object: nil, userInfo: dic)
        })
    }
}

// MARK: -- UINavigationControllerDelegate(隐藏、显示NavigationBar的动画)
extension ProfileVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isProfileVC = viewController.isKind(of: ProfileVC.self)
        self.navigationController?.setNavigationBarHidden(isProfileVC, animated: true)
    }
}

//MARK: --- 上传图片控制
extension ProfileVC:UIImagePickerControllerDelegate {
    func uploadPicAction() {
        let alertVC = UIAlertController.init(title: "上传图像", message: nil, preferredStyle: .actionSheet)
        
        let albumAction = UIAlertAction.init(title: "相机", style: .default) {
            (action:UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                
            } else {
                print("模拟其中无法打开照相机,请在真机中使用")
            }
            
        }
        
        let cameraAction = UIAlertAction.init(title: "相册", style: .default) {
            (action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (UIAlertAction) in
            
        }
        
        alertVC.addAction(albumAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(cancelAction)
        
        self.navigationController?.present(alertVC, animated: true, completion: {
            
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.showHud(in: self.view, hint: "上传中", yOffset: kScreenH*0.4)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents"
            
            let fileManager = FileManager.default
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error {
                print(error)
            }
            var flag = false
            
            //Mark: --- 压缩图片大小
            let size = CGSize(width: 80, height: 80)
            let desImage = image.reSizeImage(reSize: size)
            
            if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
                let imageData = UIImagePNGRepresentation(desImage)
                let imagePath = documentPath+"/\(userNo).png"
                print(imagePath)
                fileManager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
                let filePath: String = String(format: "%@%@", documentPath, "/\(userNo).png")
                
                
                let data = userNo.data(using: .utf8)
                
                
                if let data = data {
                    
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        //let lastData = NSData(contentsOfFile: filePath)
                        multipartFormData.append(URL.init(fileURLWithPath: filePath), withName: userNo)
                        multipartFormData.append(data, withName: "UserNo")
                    }, to: "\(DefaultURL)/Simple_online/Upload_User_Image", encodingCompletion: { (result) in
                        print(result)
                        self.showHint(in: self.view, hint: "上传成功")
                        //mark ==== 这个位置重新刷新视图， 让头像加载， 同时
                        flag = true
                        
                        if let model =  UserAuthManager.sharedManager.getUserModel() {
                            model.UserIcon = "User_Img/\(userNo).png"
                            UserAuthManager.sharedManager.saveUserInfo(userModel: model)
                        }
                        DispatchQueue.main.async(execute: {
                            if let profileHeaderView = self.profileHeaderView {
                                profileHeaderView.iconImageView.image = UIImage.init(contentsOfFile: imagePath)
                                self.navigationController(self.navigationController!, willShow: self, animated: true)
                            }
                        })
                    })
                }
                
            }
            else {
                
            }
            
            //Mark: --- 隐藏hud
            if !flag {
                self.showHint(in: self.view, hint: "网络出现问题!")
            }
            
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
}

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x:0, y:0, width:reSize.width, height:reSize.height));
        
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

