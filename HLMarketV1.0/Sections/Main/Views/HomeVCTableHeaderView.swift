//
//  HomeVCTableHeaderView.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/5/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol HomeVCTableHeaderViewDelegate {
    func homeVCHeaderCarouselView(_ carouselView: XRCarouselView!, clickImageAt index: Int)
    func homeVCHeaderConfigure(btns:[HLTopBtn])
    func homeVCHeaderBtns(_ btn:HLTopBtn, clickBtnAt index:Int)
}

class HomeVCTableHeaderView: UIView {
    
    //轮播图
    lazy var carouselView:XRCarouselView = XRCarouselView()
    
    fileprivate let carouselH :CGFloat = kScreenH/4
    fileprivate var scrollBackgroundView = UIView()
    fileprivate var scrollImageView = UIImageView()
    fileprivate var scrollView = UIScrollView()
    fileprivate var scrollLabel = UILabel()
    fileprivate var scrollTimer = Timer()
    fileprivate var topTapView = UIView()
    fileprivate var target: UIViewController!
    fileprivate lazy var bageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: 1, width: 10, height: 10))
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.red
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    fileprivate var bage: Int = 0
    fileprivate var getBage: Int {
        get {
           self.bage += 1
            if self.bage > 10 {
                self.bage = 10
            }
           return self.bage
        }
    }
    
    var btns = [HLTopBtn]()
    var btnCounts:Int?
    
    var delegate:HomeVCTableHeaderViewDelegate? {
        didSet {
            configureBtn()
        }
    }
    
    init(frame: CGRect, btnCounts:Int, target: UIViewController) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.colorFromHex(0xf6f5f5)
        self.btnCounts = btnCounts
        self.target = target
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        carouselView = XRCarouselView(imageArray: [String]() as [AnyObject], describe: [String]() as [AnyObject], andScale: CGSize(width: kScreenW, height: carouselH))
        carouselView.time = 4.0
        carouselView.delegate = self
        carouselView.setPageColor(UIColor.gray.withAlphaComponent(0.3), andCurrentPageColor: UIColor.appMainColor())
        carouselView.setDescribeTextColor(UIColor.appMainColor(), font: nil, bgColor: UIColor.clear)
        carouselView.pagePosition = PositionBottomRight
        carouselView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: carouselH)
        self.addSubview(carouselView)
        
        if let btnCounts = btnCounts {
            let btnW:CGFloat = kScreenW/CGFloat(4)
            for i in 0..<btnCounts {
                
                let x: Int = i % 4
                let y: Int = Int(i / 4)
                
                let rect = CGRect(x: CGFloat(x) * btnW, y: carouselH+20+CGFloat(y) * btnW, width: btnW, height: btnW)
                let btn = HLTopBtn.init(frame: rect)
                btn.tag = i
                self.addSubview(btn)
                btns.append(btn)
                btn.addTarget(self, action: #selector(clickedAction(sender:)), for: .touchUpInside)
                btn.setTitleColor(UIColor.colorFromHex(0x77787e), for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
                btn.backgroundColor = UIColor.colorFromHex(0xf6f5f5)
            }
        }
    }
    
    func configureBtn() {
        if let delegate = self.delegate {
            delegate.homeVCHeaderConfigure(btns: btns)
        }
    }
    
    func clickedAction(sender:HLTopBtn) {
        if let delegate = self.delegate {
            delegate.homeVCHeaderBtns(sender, clickBtnAt: sender.tag)
        }
    }
}

extension HomeVCTableHeaderView:XRCarouselViewDelegate {
    func carouselView(_ carouselView: XRCarouselView!, clickImageAt index: Int) {
        if let delegate = self.delegate {
            delegate.homeVCHeaderCarouselView(carouselView, clickImageAt: index)
        }
    }
}
