//
//  PlusReduceField.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 11/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class PlusReduceField: UITextField {

    
    
    lazy var leftViewBox = {UIView.init()}()
    lazy var rightViewBox = {UIView.init()}()
    
    lazy var reduceBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .system)
        return btn
    }()
    
    lazy var plusBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .system)
        return btn
    }()
    
    lazy var firstLine  = {UILabel.init()}()
    lazy var secondLine = {UILabel.init()}()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /*
        let tfwidth = self.bounds.size.width
        let tfheight = self.bounds.size.height
        
        
        let leftViewBox = UIView.init(frame:CGRect(x:0, y:0, width:tfwidth/3, height:tfheight))
        let rightViewBox = UIView.init(frame:CGRect(x:tfwidth/3*2, y:0, width:tfwidth/3, height:tfheight))
        
        let reduceBtn = UIButton.init(type:.system)
        reduceBtn.center = leftViewBox.center
        reduceBtn.size   = CGSize(width: 15, height: 15)
        reduceBtn.setImage(UIImage.init(named: "hlm_cart_reduce"), for: .normal)
        
        let plusBtn = UIButton.init(type:.system)
        plusBtn.center = rightViewBox.center
        plusBtn.size   = CGSize(width: 15, height: 15)
        plusBtn.setImage(UIImage.init(named: "hlm_cart_reduce"), for: .normal)
        
        let klineMarginTop:CGFloat = 3
        let firstline = UIView.init(frame:CGRect(x:tfwidth/3-1, y:klineMarginTop, width:1, height:tfheight - klineMarginTop * 2))
        let secondline = UIView.init(frame:CGRect(x:tfwidth/3*2, y:klineMarginTop, width:1, height:tfheight - klineMarginTop * 2))
        */
        leftViewBox.addSubview(reduceBtn)
        rightViewBox.addSubview(plusBtn)
        leftViewBox.addSubview(firstLine)
        rightViewBox.addSubview(secondLine)
        
        self.leftView = leftViewBox
        self.rightView = rightViewBox
        self.leftViewMode = UITextFieldViewMode.always
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    
    override func layoutSubviews() {
        let tfwidth = self.bounds.size.width
        let tfheight = self.bounds.size.height
        
        
        leftViewBox.frame = CGRect(x:0, y:0, width:tfwidth/3, height:tfheight)
        rightViewBox.frame = CGRect(x:tfwidth/3*2, y:0, width:tfwidth/3, height:tfheight)
        leftViewBox.backgroundColor = UIColor.randomColor()
        rightViewBox.backgroundColor = UIColor.randomColor()
        
        reduceBtn.center = leftViewBox.center
        reduceBtn.size   = CGSize(width: 15, height: 15)
        reduceBtn.setImage(UIImage.init(named: "hlm_cart_reduce"), for: .normal)
        
        
        plusBtn.center = rightViewBox.center
        plusBtn.size   = CGSize(width: 15, height: 15)
        plusBtn.setImage(UIImage.init(named: "hlm_cart_reduce"), for: .normal)
        
        let klineMarginTop:CGFloat = 3
        firstLine.frame = CGRect(x:tfwidth/3-1, y:klineMarginTop, width:1, height:tfheight - klineMarginTop * 2)
        secondLine.frame = CGRect(x:tfwidth/3*2, y:klineMarginTop, width:1, height:tfheight - klineMarginTop * 2)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
