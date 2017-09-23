//
//  ScanQRCodeVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/4/25.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

private let scanAnimationDuration = 3.0 //扫描时长

class ScanQRCodeVC: BaseViewController {
 
    //Mark: --- 4个遮盖图层
    var scanView:UIImageView = UIImageView.init()
    var scanSession:AVCaptureSession?
    lazy var scanLine : UIImageView = {
        let scanLine = UIImageView()
        scanLine.frame = CGRect(x: 0, y: 0, width: 180, height: 3)
        scanLine.image = UIImage(named: "QRCode_ScanLine")
        return scanLine
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "扫一扫确认收货"
        setupUI()
        view.layoutIfNeeded()
        setupScanSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScan()
    }
    
    fileprivate func startScan() {
        scanLine.layer.add(scanAnimation(), forKey: "scanAnimation")
        guard let scanSession = scanSession else { return }
        if !scanSession.isRunning {
            scanSession.startRunning()
        }
    }
    
    func setupScanSession() {
        do {
            let device  = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            //设置设备输入输出
            let input   = try AVCaptureDeviceInput(device: device)
            let output  = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //设置会话
            let  scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSessionPresetHigh)
            
            guard scanSession.canAddInput(input) else {
                return
            }
            
            guard scanSession.canAddOutput(output) else {
                return
            }
            
            scanSession.addInput(input)
            scanSession.addOutput(output)
            
            //设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code]
            
            //预览图层
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            scanPreviewLayer!.frame = view.layer.bounds
            view.layer.insertSublayer(scanPreviewLayer!, at: 0)
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = (scanPreviewLayer?.metadataOutputRectOfInterest(for: self.scanView.frame))!
            })
           //保存会话
            self.scanSession = scanSession
        
        } catch {
            print("摄像头不可用")
 
        }
    }
    
    
    func setupUI() {
        view.addSubview(scanView)
        scanView.image = UIImage.init(named: "QRCode_ScanBox")
        scanView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.width.height.equalTo(180)
        }
        
        scanView.addSubview(scanLine)
        
        for i in 0..<4 {
            let maskView = UIView.init()
            maskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            view.addSubview(maskView)
            switch i {
            case 0:
                maskView.snp.makeConstraints({ (make) in
                    make.top.left.right.equalToSuperview()
                    make.bottom.equalTo(scanView.snp.top)
                })
                
                let titleLabel = UILabel.init()
                titleLabel.text = "将取景框对准二维/条形码, 即可自动扫描"
                titleLabel.textColor = UIColor.white
                titleLabel.font = UIFont.systemFont(ofSize: 15)
                titleLabel.textAlignment = .center
                maskView.addSubview(titleLabel)
                titleLabel.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(20)
                    make.bottom.equalToSuperview().offset(-30)
                }
            case 1:
                maskView.snp.makeConstraints({ (make) in
                    make.top.bottom.equalTo(scanView)
                    make.left.equalTo(scanView.snp.right)
                    make.right.equalToSuperview()
                })
            case 2:
                maskView.snp.makeConstraints({ (make) in
                    make.top.equalTo(scanView.snp.bottom)
                    make.left.bottom.right.equalToSuperview()
                })
            default:
                maskView.snp.makeConstraints({ (make) in
                    make.top.bottom.equalTo(scanView)
                    make.left.equalToSuperview()
                    make.right.equalTo(scanView.snp.left)
                })
            }
        }
        
    }
    
    
    //扫描动画
    private func scanAnimation()->CABasicAnimation
    {
        
        let startPoint = CGPoint(x: scanLine.center.x, y: 1)
        let endPoint   = CGPoint(x: scanLine.center.x, y: 180 - 2)
        
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func playAlertSound(sound:String) {
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil)  else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        
        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        AudioServicesPlaySystemSound(soundID)
        
    }
    
}

extension ScanQRCodeVC:AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        self.scanLine.layer.removeAllAnimations()
        self.scanSession?.stopRunning()
        
        playAlertSound(sound: "noticeMusic.caf")
        
        if metadataObjects.count > 0 {
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                print(resultObj.stringValue)
                if let csheetNo = resultObj.stringValue, let userNo = UserAuthManager.sharedManager.getUserModel()?.UserNo {
                    AlamofireNetWork.required(urlString: "/Simple_online/Affirm_Receipt_Goods", method: .post, parameters: ["cSheetno":csheetNo, "UserNo":userNo, "cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: {[weak self] (result) in
                        let json = JSON(result)
                        if json["resultStatus"] == "1" {
                            self?.showHint(in: (self?.view)!, hint: "确认收货成功")
                            self?.startScan()
                            
                        } else if json["resultStatus"] == "3"{
                            self?.showHint(in: (self?.view)!, hint: "该订单已确认")
                            self?.startScan()
                        } else {
                            self?.showHint(in: (self?.view)!, hint: "该订单不存在")
                            self?.startScan()
                        }
                        
                    }) { (error) in
                        self.showHint(in: (self.view)!, hint: "网络连接异常")
                        self.startScan()
                    }
                }
            }
        }
    }
}

















