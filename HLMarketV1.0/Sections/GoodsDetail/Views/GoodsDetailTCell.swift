//
//  GoodsDetailTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/8/3.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class GoodsDetailTCell: UITableViewCell {
    
    @IBOutlet weak var marketTagLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var priceLabel1: UILabel!
    
    @IBOutlet weak var countLabel1: UILabel!
    
    @IBOutlet weak var priceLabel2: UILabel!
    
    @IBOutlet weak var countLabel2: UILabel!
    
    @IBOutlet weak var priceLabel3: UILabel!
    
    @IBOutlet weak var countLabel3: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var payStylesView: UIView!
    
    @IBOutlet weak var sendInfoLabel: UILabel!
    
    @IBOutlet weak var goodsTag1Btn: UIButton!
    
    @IBOutlet weak var goodsTag2Btn: UIButton!
    
    @IBOutlet weak var goodsTag3Btn: UIButton!
    
    var model: GoodsDetailModel? {
        didSet{
            guard let model = model else {
                return
            }
            
            self.marketTagLabel.text = model.cMarketingTags
            self.nameLabel.text = model.cGoodsName
            self.desLabel.text = model.cFeatureTags
            
            let attributedStr1 : NSMutableAttributedString = NSMutableAttributedString()
            let str_1 : NSAttributedString = NSAttributedString(string: "￥", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
            let str1_1 : NSAttributedString = NSAttributedString(string: model.bOnLine_Price.cgFloatString(), attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18)])
            attributedStr1.append(str_1)
            attributedStr1.append(str1_1)
            self.priceLabel1.attributedText = attributedStr1
            self.countLabel1.text = "零售价"
            
//            let saleNumer = arc4random_uniform(1000) + 99
//            let stockNumber = arc4random_uniform(100) + 99
//            self.detailLabel.text = "销量： \(saleNumer)件   库存： \(stockNumber)件"
            self.sendInfoLabel.text = "\(model.cSupportDistribution == "0" ? "不支持" : "支持")配送"
            
            guard model.cGoodsSpecs.count != 0 else {
                return
            }
            
            for (index,model1) in model.cGoodsSpecs[0].cSpecPrices.enumerated() {
                
                if index == 0 {
                    let attributedStr2 : NSMutableAttributedString = NSMutableAttributedString()
                    let str_2 : NSAttributedString = NSAttributedString(string: "￥", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
                    let str1_2 : NSAttributedString = NSAttributedString(string: model1.cPrice.cgFloatString(), attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18)])
                    attributedStr2.append(str_2)
                    attributedStr2.append(str1_2)
                    self.priceLabel2.attributedText = attributedStr2
                    let nsNum:NSNumber = NSNumber(value: NSString(string: model1.cUpper).floatValue)
                    let tmpUpper = nsNum.intValue
                    if tmpUpper == 0 {
                        self.countLabel2.text = "≥\(model1.cLower)\(model.cUnit)"
                    } else {
                        self.countLabel2.text = "\(model1.cLower)-\(model1.cUpper)\(model.cUnit)"
                    }
                }else if index == 1{
                    let attributedStr3 : NSMutableAttributedString = NSMutableAttributedString()
                    let str_3 : NSAttributedString = NSAttributedString(string: "￥", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
                    let str1_3 : NSAttributedString = NSAttributedString(string: model1.cPrice.cgFloatString(), attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18)])
                    attributedStr3.append(str_3)
                    attributedStr3.append(str1_3)
                    self.priceLabel3.attributedText = attributedStr3
                    let nsNum:NSNumber = NSNumber(value: NSString(string: model1.cUpper).floatValue)
                    let tmpUpper = nsNum.intValue
                    if tmpUpper == 0 {
                        self.countLabel3.text = "≥\(model1.cLower)\(model.cUnit)"
                    } else {
                        self.countLabel3.text = "\(model1.cLower)-\(model1.cUpper)\(model.cUnit)"
                    }
                }
                
            }
        }
    }
    
//    func setgoodsTag(arr: Array<GoodsTagModel>) -> Void {
//        for (index,model) in arr.enumerated() {
//            switch index {
//            case 0:
//                goodsTag1Btn.setTitle(model.Describe, for: .normal)
//                goodsTag1Btn.alpha = 1.0
//            case 1:
//                goodsTag2Btn.setTitle(model.Describe, for: .normal)
//                goodsTag2Btn.alpha = 1.0
//            case 2:
//                goodsTag3Btn.setTitle(model.Describe, for: .normal)
//                goodsTag3Btn.alpha = 1.0
//            default:
//                break
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.marketTagLabel.layer.cornerRadius = 3
        self.marketTagLabel.layer.masksToBounds = true
//        self.goodsTag1Btn.alpha = 0.0
//        self.goodsTag2Btn.alpha = 0.0
//        self.goodsTag3Btn.alpha = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
