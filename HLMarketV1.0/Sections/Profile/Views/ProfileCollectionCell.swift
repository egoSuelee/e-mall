//
//  ProfileCollectionCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 09/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit


protocol ProfileCollectionCellDelegate {
    func profileCollectionDidSelected(_ index: Int)
}


private let kProfileCollectionCellID = "kProfileCollectionCellID"

class ProfileCollectionCell: UITableViewCell {

    var delegate:ProfileCollectionCellDelegate?
    
    let itemHeight = 80.0
    let itemCount  = 5
    let itemWidth  = kScreenW / 5
    
    var topBoxView:UIView = {
        let view = UIView.init()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var titleImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "全部订单")
        return imageView
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "全部订单"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var titleArrow:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "箭头")
        return imageView
    }()
    
    lazy var sepLineLabel:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var subCollectionView:UICollectionView = {[weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:self!.itemWidth, height:80)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView.init(frame: (self?.bounds)!, collectionViewLayout: layout)
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kProfileCollectionCellID)
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(topBoxView)
        
        let tap = UITapGestureRecognizer.init()
        tap.addTarget(self, action: #selector(tapAction))
        tap.delegate = self
        topBoxView.addGestureRecognizer(tap)
        
        topBoxView.addSubview(titleImageView)
        topBoxView.addSubview(titleLabel)
        topBoxView.addSubview(titleArrow)
        topBoxView.addSubview(sepLineLabel)
        self.addSubview(subCollectionView)
        
        topBoxView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(WID)
            make.right.equalToSuperview().offset(-WID)
            make.height.equalTo(40)
        }
        
        titleImageView.snp.makeConstraints { (make) in
            make.centerY.left.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(22)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleImageView.snp.right).offset(WID/2)
        }
        titleArrow.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(7)
            make.height.equalTo(15)
        }
        sepLineLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(WID)
            make.height.equalTo(_1pxWidth)
        }
        
        
        subCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topBoxView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    func tapAction() {
        delegate?.profileCollectionDidSelected(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProfileCollectionCell{
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view!.isKind(of: UIView.self) else {
            return false
        }
        return true
    }
    
}

extension ProfileCollectionCell:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kProfileCollectionCellID, for: indexPath)
        
        
        let textArray = [("待付款", "待付款"),
                         ("待发货", "待发货"),
                         ("备货", "待取货"),
                         ("待收货", "待收货"),
                         ("已完成", "已完成")]
        
        let cellSubView:CellSubView = CellSubView.init(frame: cell.bounds)
        cellSubView.cellSubViewModel = ProfileCollectionCellModel.init(dict: ["text":textArray[indexPath.row].1, "imageName":textArray[indexPath.row].0])
        cell.addSubview(cellSubView)
        
        
        return cell;
    }
    //MARK: --- 这里进行订单页面跳转
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.profileCollectionDidSelected(indexPath.row+1)
    }
}


class CellSubView:UIView {
    
    lazy var imageView = {() -> UIImageView in
        let imageview = UIImageView.init()
        return imageview;
    }()
    
    lazy var titleLabel = {() -> UILabel in
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var cellSubViewModel:ProfileCollectionCellModel? {
        didSet {
            titleLabel.text = cellSubViewModel?.text
            let theImage = UIImage.init(named: (cellSubViewModel?.imageName)!)
            imageView.image = theImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { (maker) in
            maker.height.equalToSuperview().dividedBy(3)
            maker.width.equalTo(self.imageView.snp.height)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(self.imageView.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ProfileCollectionCellModel: NSObject {
    
    var text:String = ""
    var imageName:String = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
}

