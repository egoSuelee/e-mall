//
//  ChooseStoreCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 24/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import Kingfisher


class ChooseStoreCell: UICollectionViewCell {
    
    
    var model:StoreModel? {
        didSet {
            if let model = model {
                let redirectStoreURL = URLManager.sharedURLManager.ImageStoreUrl
                let imageUrlPath = (redirectStoreURL != nil ? redirectStoreURL! : ImageStoreUrl)  + model.image_path
                storeImageView.kf.setImage(with: URL.init(string: imageUrlPath) as Resource?, placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
                storeImageView.contentMode = .scaleAspectFill
                storeImageView.clipsToBounds = true
                storeTitleLabel.text = model.cStoreName
            }
        }
    }
    
    var marketModel:MarketModel? {
        didSet {
            if let marketModel = marketModel {
                let redirectStoreURL = URLManager.sharedURLManager.ImageStoreUrl
                let imageUrlPath = (redirectStoreURL != nil ? redirectStoreURL! : ImageStoreUrl)  + marketModel.cMarketImage!
                storeImageView.kf.setImage(with: URL.init(string: imageUrlPath) as Resource?, placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
                storeImageView.contentMode = .scaleAspectFill
                storeImageView.clipsToBounds = true
                storeTitleLabel.text = marketModel.cMarketName
            }
        }
    }
    
    
    lazy var boxView = {UIView.init()}()
    lazy var storeImageBoxView = {UIView.init()}()
    
    lazy var storeImageView = {() -> UIImageView in
    
        let imageview = UIImageView.init()
        imageview.layer.cornerRadius = (kScreenW/3-6)*0.75/2
        imageview.layer.masksToBounds = true
        imageview.layer.backgroundColor = UIColor.randomColor().cgColor
        return imageview
    }()
    
    
    
    lazy var storeTitleLabel = {() -> UILabel in
        let label = UILabel.init()
        
        label.textAlignment = .center
        label.font = font(12)
        label.textColor = UIColor.init(gray: 121)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(boxView)
        self.boxView.addSubview(storeImageBoxView)
        self.storeImageBoxView.addSubview(storeImageView)
        self.boxView.addSubview(storeTitleLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        boxView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(4, 3, 4, 3))
        }
        storeImageBoxView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(storeTitleLabel.snp.top)
            make.height.equalTo(storeTitleLabel.snp.height).multipliedBy(3)
        }
        
        storeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.2)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(storeImageView.snp.width)
        }
        
        storeTitleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(storeImageBoxView.snp.height).dividedBy(3)
        }
    }
    
    
}
