//
//  RechargeMoneyPriceTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/28.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class RechargeMoneyPriceTCell: UITableViewCell {
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var model: RechargeStrategy? {
        didSet{
            guard let model = self.model else {
                return
            }
            let string: String = "充值\(model.pay_Money!)元送\(model.excess_Money!)元"
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: string)
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 25),range: NSMakeRange(0,2))
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 27),range: NSMakeRange(2,model.pay_Money!.characters.count+1))
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 25),range: NSMakeRange(3+model.pay_Money!.characters.count,1))
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 27),range: NSMakeRange(4+model.pay_Money!.characters.count,model.excess_Money!.characters.count+1))
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1),range: NSMakeRange(2, model.pay_Money!.characters.count+1))
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1),range: NSMakeRange(4+model.pay_Money!.characters.count, model.excess_Money!.characters.count+1))
            self.priceLabel.attributedText = attributeString
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(priceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        priceLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

