//
//  AddNewAddressVC2.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/4/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

enum AddNewAddressVC2State {
    case add
    case modify
}

class AddNewAddressVC2: BaseViewController {

    //Mark: --- 用于修改用户地址的时候使用
    var state:AddNewAddressVC2State?
    var model:AddressUserModel?
    
    var titleDataSource = ["收货人", "手机号码", "服务门店", "小区/大厦", "门牌号", "标签"]
    var btnTitleSource  = ["家", "公司", "餐厅", "其他"]
    var valuesDataSource = [String]()
    var commitBtn:UIButton?
    
    var tfSource = [UITextField]()
    var fetureBtns = [UIButton]()
    
    ////Mark: --- 门店/小区是否设置标识
    var chooseAddressBtn:UIButton?
    var chooseStoreBtn:UIButton?
    var label:String = "其他"
    //Mark: --- 门店经纬度
    var storeCLLocation:CLLocationCoordinate2D?
    var storeModel:StoreAddressInfoModel?
    //Mark: --- 用户位置
    var bmkPoiInfo:BMKPoiInfo? {
        didSet {
            if let bmkPoiInfo = bmkPoiInfo {
                let reverseOption = BMKReverseGeoCodeOption.init()
                reverseOption.reverseGeoPoint = bmkPoiInfo.pt
                self.geoSearcher?.reverseGeoCode(reverseOption)
            }
        }
    }
    var province:String?
    var geoSearcher:BMKGeoCodeSearch?
    
    
    //Mark: --- 用户配送地址经纬度
    
    lazy var scrolleFormView:UIScrollView = {[weak self] in
        let rect = CGRect(x: 0, y: 20, width: kScreenW, height: 350)
        let scrolleView = UIScrollView.init(frame: rect)
        let contentSize = CGSize(width: kScreenW, height: 345)
        scrolleView.contentSize =  contentSize
        scrolleView.backgroundColor = UIColor.white
        scrolleView.bounces = false
        
        scrolleView.showsVerticalScrollIndicator = false
        scrolleView.showsHorizontalScrollIndicator = false
        return scrolleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorFromHex(0xF8F8F8)
        setupUI()
        
        if model != nil {
            self.navigationItem.title = "修改配送地址"
        } else {
            self.navigationItem.title = "添加配送地址"
        }
        self.geoSearcher = BMKGeoCodeSearch.init()
        geoSearcher?.delegate = self
        
        //Mark: --- 修改地址的话, 赋值
       
        initValueForModify()
        
    }
    
    deinit {
        self.geoSearcher = nil
    }
    
    func initValueForModify() {
        
        guard let model = model else {
            return
        }
        _ = tfSource.map {
            $0.textColor = UIColor.black
        }
        tfSource[0].text = model.UserName
        tfSource[1].text = model.Tel
        tfSource[4].text = model.Detailaddress
        self.chooseAddressBtn?.setTitle(model.District, for: .normal)
        self.chooseStoreBtn?.setTitle(model.cStoreName, for: .normal)
        _ = [self.chooseStoreBtn, self.chooseAddressBtn].map {
            $0?.setTitleColor(UIColor.black, for: .normal)
        }
        
        let storefLant = (model.Store_fLant as NSString).floatValue
        let storefLont = (model.Store_fLont as NSString).floatValue
        
        self.storeCLLocation = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(storefLant), longitude: CLLocationDegrees(storefLont))
        let modifyStoreModel = StoreAddressInfoModel.init()
        modifyStoreModel.cStoreNo = model.cStoreNo
        modifyStoreModel.city     = model.City
        modifyStoreModel.province = model.Provincial
        self.storeModel = modifyStoreModel
        
        let userfLant = (model.fLant as NSString).floatValue
        let userfLont = (model.fLont as NSString).floatValue
        
        let modifyPoiInfo = BMKPoiInfo.init()
        modifyPoiInfo.city = model.City
        modifyPoiInfo.name = model.District
        modifyPoiInfo.address = ""
        modifyPoiInfo.pt = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(userfLant), longitude: CLLocationDegrees(userfLont))
        province = model.Provincial
        label = model.label
        self.bmkPoiInfo = modifyPoiInfo
        
        _ = fetureBtns.map {
            if let label = $0.titleLabel?.text {
                if label == model.label {
                    // $0.layer.borderColor     = UIColor.deeperAppColor().cgColor
                    $0.setTitleColor(UIColor.white, for: .normal)
                    $0.layer.backgroundColor = UIColor.appTextMainColor().cgColor
                    beforeLabelBtn = $0
                }
            }
        }
        
    }

    func letKeyBorderHide() {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        view.addSubview(scrolleFormView)
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(letKeyBorderHide))
        scrolleFormView.addGestureRecognizer(tap)
        
        var tmpY:CGFloat = 0.0
        for i in 0..<titleDataSource.count {
            let cellHeight:CGFloat = 44.0
            let title = titleDataSource[i]
            
                let tfFrame = CGRect(x: 0, y: tmpY, width: kScreenW, height: cellHeight)
                let tf = UITextField.init(frame: tfFrame)
                
                tf.leftViewMode = .always
                let asideBtn = TitleLeftBtn.init(type: .custom)
                asideBtn.frame = CGRect(x: 0, y: 0, width: 100, height: cellHeight)
                asideBtn.setTitle(title, for: .normal)
                asideBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                asideBtn.setTitleColor(UIColor.colorFromHex(0x030303), for: .normal)
                tf.leftView = asideBtn
            
                scrolleFormView.addSubview(tf)
                tfSource.append(tf)
        

            if i == 3 {
                tf.isEnabled = false
                chooseAddressBtn = TitleLeftImageRightBtn.init(type: .custom)
                chooseAddressBtn?.setTitle("点击选择", for: .normal)
                chooseAddressBtn?.setTitleColor(UIColor.colorFromHex(0xcdcdcd), for: .normal)
                chooseAddressBtn?.setImage(UIImage.init(named: "hlm_home_rightArrow"), for: .normal)
                chooseAddressBtn?.frame = CGRect(x: 100, y: tmpY, width: kScreenW - 100, height: cellHeight)
                chooseAddressBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                chooseAddressBtn?.addTarget(self, action: #selector(chooseBMKAddress(sender:)), for: .touchUpInside)
                scrolleFormView.addSubview(chooseAddressBtn!)
                
            } else if i == 2 {
                tf.isEnabled = false
                chooseStoreBtn = TitleLeftImageRightBtn.init(type: .custom)
                chooseStoreBtn?.setTitle("点击选择服务门店", for: .normal)
                chooseStoreBtn?.setTitleColor(UIColor.colorFromHex(0xcdcdcd), for: .normal)
                chooseStoreBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                chooseStoreBtn?.setImage(UIImage.init(named: "hlm_home_rightArrow"), for: .normal)
                chooseStoreBtn?.frame = CGRect(x: 100, y: tmpY, width: kScreenW - 100, height: cellHeight)
                chooseStoreBtn?.addTarget(self, action: #selector(chooseStoreAction(sender:)), for: .touchUpInside)
                scrolleFormView.addSubview(chooseStoreBtn!)
                
            } else if i == 1 {
                tf.keyboardType = .numberPad
                tf.placeholder  = "请输入\(title)"
                tf.textColor    = UIColor.colorFromHex(0xcdcdcd)
                tf.font         = UIFont.systemFont(ofSize: 15)
            } else if i == 5 {
                
                tf.isEnabled = false
                
                let rect = CGRect(x: 100, y: tmpY, width: kScreenW - 100, height: cellHeight)
                let BtnView = UIView.init(frame: rect)
                scrolleFormView.addSubview(BtnView)
                var btnTmpX:CGFloat = 0
                let btnMargin:CGFloat = 20
                let btnWidth:CGFloat = (kScreenW - 100 - CGFloat(btnTitleSource.count) * btnMargin)/CGFloat(btnTitleSource.count)
                for j in 0..<btnTitleSource.count {
                    let fetureBtn = UIButton.init(type: .custom)
                    let fetureBtnRect = CGRect(x: btnTmpX, y: 10, width: btnWidth, height: cellHeight - 20)
                    fetureBtn.frame = fetureBtnRect
                    fetureBtn.setTitle(btnTitleSource[j], for: .normal)
                    fetureBtn.tag = j
                    fetureBtn.addTarget(self, action: #selector(addressLabelDidSelectAction(sender:)), for: .touchUpInside)
                    //fetureBtn.layer.borderWidth     = 1
                    fetureBtn.titleLabel?.font      = UIFont.systemFont(ofSize: 15)
                    fetureBtn.layer.cornerRadius    = 3
                    fetureBtn.layer.masksToBounds   = true
                    //fetureBtn.layer.borderColor     = UIColor.colorFromHex(0x979797).cgColor
                    fetureBtn.setTitleColor(UIColor.colorFromHex(0x979797), for: .normal)
                    btnTmpX = btnTmpX + btnMargin + btnWidth
                    BtnView.addSubview(fetureBtn)
                    fetureBtns.append(fetureBtn)
                }
                
                
            } else {
                tf.placeholder  = "请输入\(title)"
                tf.textColor    = UIColor.colorFromHex(0xcdcdcd)
                tf.font         = UIFont.systemFont(ofSize: 15)
            }
            
            //设置代理
            tf.delegate = self

            
            tmpY = tmpY + cellHeight
            let sepFrame = CGRect(x: WID, y: tmpY - 1, width: kScreenW - 20, height: 0.5)
            let sepView  = UIView.init(frame: sepFrame)
            sepView.backgroundColor = UIColor.colorFromHex(0xf1f1f1)
            scrolleFormView.addSubview(sepView)
            
        }
        
        //Mark: --- 提交按钮
        commitBtn = HighLightedBtn.init(frame: CGRect(x: WID, y: tmpY + 30, width: kScreenW - 2 * WID, height: 44), 0xff3951)
        //commitBtn?.frame = CGRect(x: WID, y: tmpY + 30, width: kScreenW - 2 * WID, height: 44)
        //commitBtn?.layer.backgroundColor = UIColor.appMainColor().cgColor
        commitBtn?.layer.cornerRadius    = 3
        commitBtn?.layer.masksToBounds   = true
        //commitBtn?.layer.borderWidth     = 0.5
        //commitBtn?.layer.borderColor     = UIColor.appMainColor().cgColor
        commitBtn?.setTitle("保存地址", for: .normal)
        commitBtn?.addTarget(self, action: #selector(saveAddressAction), for: .touchUpInside)
        scrolleFormView.addSubview(commitBtn!)
        
    }

    func saveAddressAction() {
        if tfSource[0].text?.characters.count == 0 {
            showHint(in: view, hint: "收货人不能为空")
            return
        } else if tfSource[1].text?.characters.count == 0 {
            showHint(in: view, hint: "电话不能为空")
            return
        } else if tfSource[4].text?.characters.count == 0 {
            showHint(in: view, hint: "门牌号不能为空")
            return
        } else if self.storeCLLocation == nil {
            showHint(in: view, hint: "请选择服务门店")
            return
        } else if self.bmkPoiInfo == nil || province == nil {
            showHint(in: view, hint: "请选择您的小区位置")
            return
        }
        
        guard (tfSource[1].text?.isMatch(patternString: PHONE_REG_PATTERN))! else {
            showHint(in: view, hint: "请输入正确的手机号格式")
            return
        }
        
        
        
        
        if let labelBtn = beforeLabelBtn {
            label = btnTitleSource[labelBtn.tag]
        }
        
        if model == nil {
            commitAddressAction()
        } else {
            updateAddressAction()
        }
    }
    
    func updateAddressAction() {
        
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
            self.showHud(in: self.view)
            AlamofireNetWork.required(urlString: "/Simple_online/Update_User_Address", method: .post, parameters: ["UserNo":userNo,"AddressID":(model?.AddressID)!,"Tel":tfSource[1].text!,"UserName":tfSource[0].text!,"Provincial":province!,"City":(bmkPoiInfo?.city)!,"District":(bmkPoiInfo?.name)!,"Detailaddress":"\((bmkPoiInfo!.address)!)\((tfSource[4].text)!)","Default_fage":"1","cStoreNo":(storeModel?.cStoreNo)!, "label":label, "fLont":"\(bmkPoiInfo!.pt.longitude)", "fLant":"\(bmkPoiInfo!.pt.latitude)"], success: { [weak self](result) in
                let json = JSON(result)
                if json["resultStatus"] == "1" {
                    self?.hideHud()
                    DispatchQueue.main.async(execute: {
                        //MARK: --- 发送通知, 告知信息被更改, 请求刷新数据
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: addressInfoChanged), object: self, userInfo: [:])
                        _ = self?.navigationController?.popViewController(animated: true)
                    })
                }else{
                    self?.showHint(in: (self?.view)!, hint: "修改地址失败")
                }
            }) { (error) in
                self.showHint(in: self.view, hint: "请求失败")
            }
            
        }
    }

    func commitAddressAction() {
        
        if let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo{
            self.showHud(in: self.view)
            AlamofireNetWork.required(urlString: "/Simple_online/Add_User_Address", method: .post, parameters: ["UserNo":userNo,"Tel":tfSource[1].text!,"UserName":tfSource[0].text!,"Provincial":"\(province!)","City":(bmkPoiInfo!.city)!,"District":(bmkPoiInfo!.name)!, "Detailaddress":"\((bmkPoiInfo!.address)!)\( (tfSource[4].text)!)","Default_fage":"0","fLont":"\(bmkPoiInfo!.pt.longitude)","fLant":"\(bmkPoiInfo!.pt.latitude)","cStoreNo":"\(storeModel!.cStoreNo)","label":"\(label)",],
                success: { [weak self](result) in
                    let json = JSON(result)
                    if json["resultStatus"] == "1" {
                        self?.hideHud()
                        DispatchQueue.main.async(execute: {
                    //MARK: --- 发送通知, 告知信息被更改, 请求刷新数据
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: addressInfoChanged), object: self, userInfo: [:])
                            _ = self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.showHint(in: (self?.view)!, hint: "添加地址失败")
                    }
            }) { (error) in
                self.showHint(in: self.view, hint: "请求失败")
            }
        }
    }
    
    ////Mark: --- 保存当前的btn
    var beforeLabelBtn:UIButton?
    
    func addressLabelDidSelectAction(sender:UIButton) {
        if let beforeBtn = beforeLabelBtn {
            beforeBtn.layer.borderColor     = UIColor.colorFromHex(0x979797).cgColor
            beforeBtn.setTitleColor(UIColor.colorFromHex(0x979797), for: .normal)
            beforeBtn.layer.backgroundColor = UIColor.clear.cgColor
        }
       
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.layer.backgroundColor = UIColor.appTextMainColor().cgColor
        beforeLabelBtn = sender
    }
    func chooseBMKAddress(sender:UIButton) {
        if storeCLLocation != nil {
            let VC = BMKChooseAddressVC()
            VC.storeLocation = storeCLLocation
            VC.storeModel    = storeModel
            VC.chooseFinished = { (bmkPoiInfo:BMKPoiInfo) in
                sender.setTitle(bmkPoiInfo.name, for: .normal)
                sender.setTitleColor(UIColor.black, for: .normal)
                sender.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                self.bmkPoiInfo = bmkPoiInfo
            }
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            showHint(in: view, hint: "请先选择服务门店")
        }
    }
    
    func chooseStoreAction(sender:UIButton) {
        let VC = ChooseStoreAddressVC()
        VC.chooseFinished = {(model) in
            if model.cStoreNo != self.model?.cStoreNo {
                self.bmkPoiInfo = nil
                self.chooseAddressBtn?.setTitle("点击选择", for: .normal)
                self.chooseAddressBtn?.setTitleColor(UIColor.colorFromHex(0xcdcdcd), for: .normal)
                self.province = nil
                self.tfSource[4].text = nil
            }
            
            let flant = (model.fLant as NSString).doubleValue
            let flont = (model.fLont as NSString).doubleValue
            
            sender.setTitle(model.cStoreName, for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            self.storeCLLocation = CLLocationCoordinate2D.init(latitude: flant, longitude: flont)
            self.storeModel = model
            
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

extension AddNewAddressVC2:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.textColor = UIColor.black
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddNewAddressVC2:BMKGeoCodeSearchDelegate {
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        switch error {
        case BMK_SEARCH_NO_ERROR:
            province = result.addressDetail.province
        default:
            print(error)
        }
    }
    
}





class TitleLeftBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var titleRect = titleLabel?.frame
        titleRect?.origin.x = WID
        titleLabel?.frame = titleRect!
    }
    
}
class TitleLeftImageRightBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var titleRect = titleLabel?.frame
        var imageViewRect = imageView?.frame
        
        titleRect?.origin.x = 0
        titleLabel?.frame = titleRect!
        imageViewRect?.origin.x = self.width - WID - (imageViewRect?.size.width)!
        imageView?.frame = imageViewRect!
    }
    
}
