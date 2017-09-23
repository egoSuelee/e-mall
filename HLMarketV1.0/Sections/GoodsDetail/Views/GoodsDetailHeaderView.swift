//
//  GoodsDetailHeaderView.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/8/3.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Kingfisher

class GoodsDetailHeaderView: UIView {
    
    fileprivate lazy var scrollView: UIScrollView = { [weak self] in
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.appMainColor()
        pageControl.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.3)
        return pageControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    func setHeaderImages(images: [GoodsImageModel]) {
        _ = scrollView.subviews.map{
            $0.removeFromSuperview()
        }
        
        guard images.count != 0 else {
            return
        }
        
        for (index,image) in images.enumerated() {
            let imageView = UIImageView.init(frame: CGRect(x: kScreenW * CGFloat(index), y: 0, width: kScreenW, height: kScreenW))
            let redirectImageGoodsUrl = URLManager.sharedURLManager.ImageGoodsUrl
            imageView.kf.setImage(with: URL.init(string: (redirectImageGoodsUrl != nil ? redirectImageGoodsUrl! :ImageGoodsUrl) + image.cGoodsImagePath), placeholder: #imageLiteral(resourceName: "hlm_placeholder_quadrate_large"))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize.init(width: kScreenW * CGFloat(images.count), height: 0)
        
        if images.count == 1 {
            pageControl.alpha = 0
        }else {
            pageControl.alpha = 1
        }
         pageControl.numberOfPages = images.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-WID)
        }
    }

}

extension GoodsDetailHeaderView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / kScreenW)
        pageControl.currentPage = page
    }
}
