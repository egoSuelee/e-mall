//
//  GoodsDetailGuessYouLikeTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/8/4.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

let kGoodsDetailGuessYouLikeCCellID = "kGoodsDetailGuessYouLikeCCellID"

class GoodsDetailGuessYouLikeTCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (kScreenW - 3 * 8)/2.0
        let size = CGSize(width:itemWidth, height:itemWidth*1.5)
        layout.itemSize = size
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.isScrollEnabled = false
        collectionView.register(ShopCartStyleCell.self, forCellWithReuseIdentifier: kGoodsDetailGuessYouLikeCCellID)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
