//
//  PF_OrderFooterView.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/8/4.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

protocol PF_OrderFooterViewDelegate {
    func pf_orderFooterBtnDidClick(index:Int, section:Int?)
}

fileprivate let baseTextSize = kHOrderGoodsCellHeight / 10

class PF_OrderFooterView: UIView {

    fileprivate var contentView = UIView.init()
    fileprivate var sepView = UIView.init()
    var state:PFOrderState?     
    var section:Int?
    var delegate:PF_OrderFooterViewDelegate?
    
    lazy var tongjiLabel:UILabel = {[weak self] in
        var label = UILabel.init()
        label.textAlignment = .right
        label.textColor = UIColor.colorFromHex(0x585858)
        label.font = UIFont.systemFont(ofSize: baseTextSize*2.7*0.5)
        return label
    }()
    
    var btnArr:[UIButton] = [UIButton]()
    
    lazy var btnsView:UIView = {[weak self] in
        let view = UIView.init()
        return view
        }()
    
    lazy var line:UIView = {[weak self] in
        let view = UIView.init()
        view.backgroundColor = UIColor.colorFromHex(0xf7f7fc)
        return view
        }()
    
   init(frame: CGRect, state: PFOrderState) {
        super.init(frame: frame)
        self.state = state
        setupUI()
    }
    func setupUI() {
        self.backgroundColor = UIColor.white
        _ = [sepView, contentView].map {
            self.addSubview($0)
        }
        sepView.backgroundColor = UIColor.colorFromHex(0xf7f7fc)
        _ = [tongjiLabel, line, btnsView].map {
            contentView.addSubview($0)
        }
        layoutUI()
        setupBtn()
        
    }
    
     func layoutUI() {
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(kHOrderGoodsCellHeight)
        }
        
        sepView.snp.makeConstraints{(make) in
            make.top.equalTo(contentView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        tongjiLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(tongjiLabel)
            make.top.equalTo(tongjiLabel.snp.bottom)
            make.height.equalTo(_1pxWidth)
        }
        btnsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(line)
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func setupBtn() {
        layoutIfNeeded()
        for i in 0..<4 {
            let btnWidth:CGFloat = (kScreenW-16-12*3)/4
            let btnHeight:CGFloat = ((kHOrderGoodsCellHeight*0.6)-_1pxWidth)*0.6
            let margin_top:CGFloat = ((kHOrderGoodsCellHeight*0.6)-_1pxWidth)*0.2
            let btn = UIButton.init(type: .custom)
            
            btn.tag = i
            btnsView.addSubview(btn)
            btnArr.append(btn)
            btn.addTarget(self, action: #selector(orderBtnClicked(sender:)), for: .touchUpInside)
            btn.frame = CGRect.init(x: CGFloat(i) * (btnWidth+12), y: margin_top, width: btnWidth, height: btnHeight)
            setBtnStyleNormal(btn: btn)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: baseTextSize * 1.5)
        }
        
        guard let state = state else {
            return
        }
        if btnArr.count != 4 {
            return
        }
        switch state {
        case .unpay:
            btnArr[0].alpha = 0
            btnArr[1].setTitle("联系卖家", for: .normal)
            btnArr[2].setTitle("取消订单", for: .normal)
            btnArr[3].setTitle("继续支付", for: .normal)
            setBtnStyleSpecial(btn: btnArr[3])
        case .unpost,.unbeihuo:
            btnArr[0].alpha = 0
            btnArr[1].alpha = 0
            btnArr[2].alpha = 0
            btnArr[3].setTitle("联系卖家", for: .normal)
        case .unreceive,.untake:
            btnArr[0].alpha = 0
            btnArr[1].alpha = 0
            btnArr[2].setTitle("联系卖家", for: .normal)
            btnArr[3].setTitle("确认收货", for: .normal)
            setBtnStyleSpecial(btn: btnArr[3])
        default:
            btnArr[0].alpha = 0
            btnArr[1].alpha = 0
            btnArr[2].alpha = 0
            btnArr[3].setTitle("联系卖家", for: .normal)
        }
        

    }
    
    func orderBtnClicked(sender:UIButton) {
        guard let delegate = delegate else {
            return
        }
        delegate.pf_orderFooterBtnDidClick(index: sender.tag, section: section)
    }
    
    
    func setBtnStyleNormal(btn:UIButton) {
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderColor = UIColor.colorFromHex(0xd5d5d5).cgColor
        btn.layer.borderWidth = _1pxWidth
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitleColor(UIColor.colorFromHex(0x858585), for: .normal)
    }
    
    func setBtnStyleSpecial(btn:UIButton) {
        btn.layer.backgroundColor = UIColor.appMainColor().cgColor
        btn.layer.borderColor = UIColor.appTextMainColor().cgColor
        btn.layer.borderWidth = _1pxWidth
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitleColor(UIColor.colorFromHex(0xffffff), for: .normal)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
