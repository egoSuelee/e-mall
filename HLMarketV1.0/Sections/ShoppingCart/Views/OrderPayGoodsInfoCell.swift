//
//  OrderPayGoodsInfoCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 13/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class OrderPayGoodsInfoCell: UITableViewCell {

    lazy var goodsControlView:GoodsControlView = {[weak self]() -> GoodsControlView in
        let rect = CGRect.zero
        let view = GoodsControlView.init(frame: rect, type: .counts)
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(goodsControlView)
    }
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.size.height -= 1
            super.frame = newFrame
        }
    }
    
    override func layoutSubviews() {
        goodsControlView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

