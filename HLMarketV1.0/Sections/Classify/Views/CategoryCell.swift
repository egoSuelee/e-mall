//
//  CategoryCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/7/25.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    var model:ClassifyTypeModel? {
        didSet {
            guard let model = model else {
                return
            }
            let redirectImageTypeUrl = URLManager.sharedURLManager.ImageTypeUrl
            goodsTypeImage.kf.setImage(with: URL.init(string: (redirectImageTypeUrl != nil ? redirectImageTypeUrl! :ImageTypeUrl) + model.ImagePath) as Resource?, placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
            goodsTypeImage.contentMode = .scaleAspectFill
            goodsTypeImage.clipsToBounds = true
            goodsLabel.text = model.cCategoryAlias
        }
    }
    
    lazy var goodsTypeImage:UIImageView = {[weak self] in
        let image = UIImageView.init()
        image.contentMode = .scaleAspectFill
        return image
        }()
    
    lazy var goodsLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.colorFromHex(0x3a3a3a)
        label.textAlignment = .center
        return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = [goodsTypeImage, goodsLabel].map {
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        goodsTypeImage.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(goodsTypeImage.snp.width)
        }
        goodsLabel.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(goodsTypeImage.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
