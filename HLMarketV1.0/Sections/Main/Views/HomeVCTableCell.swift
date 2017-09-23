

//
//  HomeVCTableCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 2017/5/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HomeVCTableCell: UITableViewCell {

    var models:[ShopCartStyleModel]? {
        didSet {
            guard models != nil else {
                return
            }
            self.collectionView.reloadData()
        }
    }
    
    var targetVC: UIViewController!
    
    lazy var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    lazy var collectionView:UICollectionView = {[weak self] in
        var collView = UICollectionView.init(frame: (self?.bounds)!, collectionViewLayout: (self?.flowLayout)!)
        collView.backgroundColor = UIColor.colorFromHex(0xf6f5f5)
        collView.delegate = self
        collView.dataSource = self
        collView.register(ShopCartStyleCell.self, forCellWithReuseIdentifier: "HomeTableCELLForCollection")
        collView.bounces = false
        collView.showsHorizontalScrollIndicator = false
        return collView
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func initFlowLayout() {
        flowLayout.itemSize = CGSize(width: (kScreenW-8*4) / 3, height: (self.frame.size.height-8*2))
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .horizontal
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initFlowLayout()
        self.contentView.addSubview(collectionView)
    }
}

extension HomeVCTableCell:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  models == nil  {
            return 0
        } else {
            return (self.models?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTableCELLForCollection", for: indexPath) as! ShopCartStyleCell
        cell.shopCartModel = models?[indexPath.row]
        
        cell.addGoodsToShopCartBlock = { (state,message) in
            self.targetVC.showHint(in: self.targetVC.view, hint: message)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = self.models![indexPath.row]
        
        let vc = GoodsDetailVC()
        vc.cGoodsNo = model.cGoodsNo
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
}
















