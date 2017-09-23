//
//  HLCurrentLocation.swift
//  华隆滴购
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class HLCurrentLocation: NSObject ,BMKGeneralDelegate, BMKLocationServiceDelegate{
    
    var locationService: BMKLocationService!
    var backCurentLocation:((_ curentLocation:BMKUserLocation?,_ success:Bool) -> ())?
    // MARK: 单例
    class var sharedManager:HLCurrentLocation {
        struct Static {
            static let instance:HLCurrentLocation = HLCurrentLocation()
        }
        return Static.instance
    }
    // MARK: 开始定位
    func getUSerLocation(){
        
        self.initService()
        
    }
    // MARK: 初始化搜索类
    func initService(){
        locationService = BMKLocationService()
//        locationService.allowsBackgroundLocationUpdates = true
        locationService.delegate = self
        locationService.startUserLocationService()
    }
    
    // MARK: - BMKLocationServiceDelegate
    
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
//        print("willStartLocatingUser");
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        if self.backCurentLocation != nil {
            self.backCurentLocation!(userLocation,true)
        }
        
        locationService.stopUserLocationService()
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
//        print("didStopLocatingUser")
    }
    
    func didFailToLocateUserWithError(_ error: Error!) {
        if self.backCurentLocation != nil {
            self.backCurentLocation!(nil,false)
        }
        
        locationService.stopUserLocationService()
    }
   
    
}

