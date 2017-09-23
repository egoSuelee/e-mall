//
//  ProfileInfoLabelCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 09/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import Foundation

private let kProfileLabelCellMargin:CGFloat = 5
private let kProfileLabelCellGrayViewMargin:CGFloat = 2

typealias BtnClickClosure = (_ tuple:(Int,Int))->Void

class ProfileInfoLabelCell: UITableViewCell {
    
    var btnClickClosure:BtnClickClosure?
    var BtnTypeValue:Int = 0
    var boxBtnsArray:[UIButton]? = []
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
     

    func setupUI() {
        //MARK: -- 这个方法很蠢, 最好的方法是在创建button的时候设置一个逃逸闭包, 用来改变label的值
        self.boxBtnsArray?.removeAll()
        _ = self.contentView.subviews.map{$0.removeFromSuperview()}
        
        var i = 0
        while i < boxCount {
            self.boxBtnsArray?.append(self.createOneBoxBtn((textArray?[i])!))
            i += 1
        }
    }
    
    func layoutUI() {
        
        let totalBtnWidth = CGFloat(kScreenW) - (CGFloat(boxCount) - 1)*kProfileLabelCellGrayViewMargin - CGFloat(boxCount) * 2 * kProfileLabelCellMargin
        let btnWidth = totalBtnWidth / CGFloat(boxCount)
        for (index,btn) in boxBtnsArray!.enumerated() {
            let kMarginLeft = kProfileLabelCellMargin +  CGFloat(index) * (btnWidth + kProfileLabelCellGrayViewMargin + 2 * kProfileLabelCellMargin)
            btn.frame = CGRect(x: kMarginLeft, y: kProfileLabelCellMargin, width:btnWidth, height: self.bounds.size.height)

            btn.tag = index + 1

            self.contentView.addSubview(btn)
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        }
        var labelIndex = 0
        repeat {
            let labelheiHei = (self.bounds.size.height - 2 * kProfileLabelCellMargin)/2
            let labelBounds = CGRect(x: CGFloat(labelIndex + 1) * (btnWidth + 2 * kProfileLabelCellMargin) + CGFloat(labelIndex)*kProfileLabelCellGrayViewMargin, y: kProfileLabelCellMargin+labelheiHei/2, width: kProfileLabelCellGrayViewMargin, height: labelheiHei)
            let sepLineLabel = UILabel.init(frame:labelBounds)
            sepLineLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.07)
            
            self.contentView.addSubview(sepLineLabel)
            labelIndex += 1
        } while labelIndex < boxCount - 1
    }
    
    
    
    func btnClick(sender:UIButton) {
        if (btnClickClosure != nil) {
            btnClickClosure!((self.BtnTypeValue,sender.tag))
        }
    }
    //-------------  建议数值不要超过4
    var boxCount:Int {
        get {
            if textArray != nil {
                return (textArray?.count)!
            } else {
                return 0
            }
        }
    }
    
    var textArray:[(values:String, title: String)]? {
        didSet {
            setupUI()
            layoutUI()
            }
        }
    
    func createOneBoxBtn(_ tupleTitle:(values:String, title:String)) -> UIButton {
        let boxBtn = UIButton.init(type: UIButtonType.system)
        
        let topLabel = UILabel.init()
        let botLabel = UILabel.init()
        
        boxBtn.addSubview(topLabel)
        boxBtn.addSubview(botLabel)
        
        topLabel.textAlignment = NSTextAlignment.center
        botLabel.textAlignment = NSTextAlignment.center
        
        topLabel.font = UIFont.systemFont(ofSize: 16)
        botLabel.font = UIFont.systemFont(ofSize: 12)
        
        topLabel.textColor = UIColor.appMainColor()
        
        topLabel.text = tupleTitle.values
        botLabel.text = tupleTitle.title
        
        topLabel.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.left.top.width.equalToSuperview()
        }
        botLabel.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.left.bottom.width.equalToSuperview()
        }
        
        return boxBtn
    }
    
    
}
