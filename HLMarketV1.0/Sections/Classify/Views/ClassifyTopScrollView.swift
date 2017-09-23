//
//  ClassifyTopScrollView.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/26.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class ClassifyTopScrollView: UIView {

    fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate var bottomView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.appMainColor()
        return view
        
    }()
    
    fileprivate var selectIndex = 1
    
    fileprivate let btnWid: Int = 80
    
    var modelArr: [ClassifyTypeModel]? {
        didSet{
            
            _ = self.scrollView.subviews.map { (view) -> Void in
                view.removeFromSuperview()
            }
            
            selectIndex = 1
            
            for i in 0..<modelArr!.count {
                
                let btn = UIButton(frame: CGRect(x: i*btnWid, y: 5, width: btnWid, height: Int(frame.height-10)))
                btn.tag = i+1
                btn.layer.cornerRadius = btn.frame.height/2
                btn.layer.masksToBounds = true
                btn.titleLabel?.textAlignment = .center
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitle(modelArr![i].cGroupTypeName, for: .normal)
                btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
                scrollView.addSubview(btn)
                
                if i == 0 {
                    btn.setTitleColor(UIColor.white, for: .normal)
                    btn.backgroundColor = UIColor.appMainColor()
                    self.selectBlock!(self.modelArr![0],0)
                }else{
                    btn.setTitleColor(UIColor.init(gray: 110), for: .normal)
                    btn.backgroundColor = UIColor.white
                }
            }
            
            scrollView.contentSize = CGSize(width:modelArr!.count*btnWid, height: 0)
            
        }
    }
    
    var selectBlock: ((_ model: ClassifyTypeModel, _ index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(scrollView)
        self.bottomView.frame = CGRect(x: 0, y: frame.height-2, width: frame.width, height: 1)
        self.addSubview(bottomView)
    }
    
    func btnAction(btn: UIButton) -> Void {
        guard btn.tag != selectIndex else {
            return
        }
        
        let btnOld = viewWithTag(selectIndex) as! UIButton
        btnOld.setTitleColor(UIColor.init(gray: 110), for: .normal)
        
        btnOld.backgroundColor = UIColor.white
        selectIndex = btn.tag
        
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.appMainColor()
        
        guard self.scrollView.contentSize.width > self.frame.width else {
            if self.selectBlock != nil {
                self.selectBlock!(self.modelArr![btn.tag-1],btn.tag-1)
            }
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            let x: CGFloat = btn.frame.minX - (self.frame.width - CGFloat(self.btnWid))/2
            
            switch x {
            case let x where x < 0:
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            case (0...(self.scrollView.contentSize.width-(self.frame.width))):
                self.scrollView.contentOffset = CGPoint(x: x, y: 0)
            case let x where x > (self.scrollView.contentSize.width-(self.frame.width)):
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentSize.width-(self.frame.width), y: 0)
            default:
                break
            }
            
        }) { (completion) in
            if self.selectBlock != nil {
                self.selectBlock!(self.modelArr![btn.tag-1],btn.tag-1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
