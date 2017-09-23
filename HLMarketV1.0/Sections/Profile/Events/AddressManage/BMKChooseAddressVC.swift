//
//  BMKChooseAddressVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/4/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class BMKChooseAddressVC: BaseViewController {

    var storeLocation:CLLocationCoordinate2D?
    var storeModel:StoreAddressInfoModel?
    
    var chooseFinished:((_ bmkPoiInfo:BMKPoiInfo)->Void)?
    var targetAnno:BMKPointAnnotation?
    var bmkPoiSearch = BMKPoiSearch.init()
    var dataSource:[BMKPoiInfo]? {
        didSet {
            if let dataSource = dataSource {
                self.dataSource = dataSource.filter {
                    BMKCircleContainsCoordinate($0.pt, storeLocation!, 3000)
                }
                DispatchQueue.main.async(execute: { 
                    self.hideHud()
                    self.nearByTableView.reloadData()
                })
                
            }
        }
    }
    
    lazy var bmkMapView:BMKMapView  = {[weak self] in
        let tmpY = (kScreenH - kNavigationBarH - kStatusBarH) * 0.5
        let _bmkMapView = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: tmpY))
        _bmkMapView.delegate = self
        //Mark: --- 设置图像的缩放级别, 也可以通过mapStatus获取地图的中心点(地图的中心店就是周边雷达的检索中心点)
        let mapStatus = BMKMapStatus.init()
        mapStatus.fLevel = 13
        _bmkMapView.setMapStatus(mapStatus)
        
        return _bmkMapView
    }()
    
    lazy var searchTF:TitleRightImageLeftBtn = {[weak self] in
        let btnFrame = CGRect(x: WID, y: 6, width: kScreenW - 2 * WID, height: 40)
        let btn = TitleRightImageLeftBtn.init(type: .custom)
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderColor = UIColor.init(gray: 200).cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.frame = btnFrame
        
        btn.setImage(UIImage.init(named: "hlm_search_icon"), for: .normal)
        btn.setTitle("搜索附近的小区, 写字楼, 餐厅等", for: .normal)
        btn.setTitleColor(UIColor.colorFromHex(0xcdcdcd), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(toSearchPageAction), for: .touchUpInside)
        return btn
        }()
    func toSearchPageAction() {
        let VC = BMKSearchVC()
        VC.storeLocation = self.storeLocation
        VC.storeModel    = self.storeModel
        ////Mark: --- 回调
        VC.chooseFinished = { (model) in
            if let myFinised = self.chooseFinished {
                myFinised(model)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //Mark: --- 懒加载视图
    lazy var nearByTableView:UITableView = {[weak self] in
        let tmpY = (kScreenH - kNavigationBarH - kStatusBarH) * 0.5
        let _nearByTableView = UITableView.init(frame: CGRect(x: 0, y: tmpY, width: kScreenW, height: (kScreenH - kNavigationBarH - kStatusBarH) * 0.5), style: .plain)
        _nearByTableView.dataSource = self
        _nearByTableView.delegate   = self
        _nearByTableView.bounces    = false
        _nearByTableView.separatorStyle = .none
        _nearByTableView.register(ChooseStoreAddressCell.self, forCellReuseIdentifier: "BMKChooseAddressVCCELLID")
        return _nearByTableView
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let storeModel = storeModel {
            self.navigationItem.title = storeModel.city
        }
        configureMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bmkPoiSearch.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        bmkPoiSearch.delegate = nil
    }
    
    func configureMapView() {
        showHud(in: view)
            //给商铺添加大头针 + 给商铺画圆
            if let storeLocation = self.storeLocation {
                self.bmkMapView.setCenter(storeLocation, animated: true)
                
                let anno = BMKPointAnnotation.init()
                anno.coordinate = storeLocation
                anno.subtitle = "storeAnno"
                
                self.targetAnno = BMKPointAnnotation.init()
                self.targetAnno?.coordinate = storeLocation
                self.targetAnno?.subtitle = "targetAnno"
                
                
                let circle = BMKCircle.init(center:self.storeLocation!, radius: 3000)
                
            
                DispatchQueue.main.async(execute: {
                    self.bmkMapView.add(circle)
                    self.bmkMapView.addAnnotations([anno, self.targetAnno!])
                    self.view.addSubview(self.bmkMapView)
                    self.view.addSubview(self.nearByTableView)
                    self.bmkMapView.addSubview(self.searchTF)
                    self.hideHud()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.showHint(in: self.view, hint: "加载地图失败")
                })
            }
    }
   
}

extension BMKChooseAddressVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource != nil {
            return (self.dataSource?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BMKChooseAddressVCCELLID", for: indexPath) as! ChooseStoreAddressCell
        if let source = self.dataSource {
            let poiInfo = source[indexPath.row]
            cell.bmkModel = poiInfo
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init()
        headerView.backgroundColor = UIColor.colorFromHex(0xf3f3f3)
        let label = UILabel.init()
        label.text = "附近地址"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.frame = CGRect(x: WID, y: 0, width: kScreenW, height: 30)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let chooseFinised = self.chooseFinished {
            chooseFinised((self.dataSource?[indexPath.row])!)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension BMKChooseAddressVC:BMKMapViewDelegate {
    
    //圆
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        
        if overlay.isKind(of: BMKCircle.self) {
            let circleView = BMKCircleView.init(circle: overlay as! BMKCircle!)
            circleView?.fillColor = UIColor.appMainColor().withAlphaComponent(0.07)
            circleView?.strokeColor = UIColor.appMainColor().withAlphaComponent(0.7)
            circleView?.lineWidth = 1.0
            return circleView
        }
        return nil
    }
    
    //拖拽地图
    func  mapView(_ mapView: BMKMapView!, onDrawMapFrame status: BMKMapStatus!) {
        if let targetAnno = self.targetAnno {
            DispatchQueue.main.async(execute: { 
                targetAnno.coordinate = status.targetGeoPt
            })
        }
       
        showHud(in: view)
        let option = BMKNearbySearchOption.init()
        option.location = status.targetGeoPt
        option.radius   = 3000
        option.keyword  = "住宅小区"
        option.pageCapacity = 30
        let flag = bmkPoiSearch.poiSearchNear(by: option)
        if flag {
            NSLog("检索成功")
        } else {
            NSLog("检索失败")
        }
    }
    
    //自定义大头针
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        print(annotation.subtitle!())
        if annotation.subtitle!() == "storeAnno" {
            let bmkAnnoView = BMKAnnotationView.init(annotation: annotation, reuseIdentifier: "StoreAnnoView")
            bmkAnnoView?.image = UIImage.init(named: "hlm_store_anno")
            return bmkAnnoView
        } else {
            let bmkAnnoView = BMKAnnotationView.init(annotation: annotation, reuseIdentifier: "TargetAnnoView")
            bmkAnnoView?.image = UIImage.init(named: "hlm_address_anno")
            return bmkAnnoView
        }
    }
    
}

extension BMKChooseAddressVC:BMKPoiSearchDelegate {
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        switch errorCode {
        case BMK_SEARCH_NO_ERROR:
            self.dataSource = poiResult.poiInfoList as? [BMKPoiInfo]
            
        default:
            showHint(in: view, hint: "暂无可用地址")
            print(errorCode)
        }
    }
    
    func onGetPoiDetailResult(_ searcher: BMKPoiSearch!, result poiDetailResult: BMKPoiDetailResult!, errorCode: BMKSearchErrorCode) {
        
    }
    
}

class TitleRightImageLeftBtn: UIButton {
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
        
        
        imageViewRect?.origin.x = 10
        imageView?.frame = imageViewRect!
        titleRect?.origin.x = (imageViewRect?.origin.x)! + (imageViewRect?.size.width)! + WID
        titleLabel?.frame = titleRect!
    }
    
}











