//
//  SearchHistoryView.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/3/11.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

fileprivate let SearchHistoryCellID = "SearchHistoryCellID"
fileprivate let SearchHistoryHeaderID = "SearchHistoryHeaderID"
let SearchHistoryDBName = "HLSearchHistory"

typealias SearchHistorySelectBlock = (_ str: String) -> Void

class SearchHistoryView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {
    
    var selectBlock: SearchHistorySelectBlock?
    
    fileprivate lazy var collectionView: UICollectionView  = { [weak self] in
        let layout = SearchHistoryLayout()
        layout.maximumSpacing = 15
        let colView = UICollectionView(frame: self!.bounds, collectionViewLayout:layout)
        colView.delegate = self
        colView.dataSource = self
        colView.register(SearchHistoryCollectionViewCell.self, forCellWithReuseIdentifier: SearchHistoryCellID)
        colView.register(SearchHistoryHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchHistoryHeaderID)
        colView.backgroundColor = UIColor.white
        return colView
    }()
    
    fileprivate var dataArr = [[String:String]]()
    
    override init( frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        addSubview(collectionView)
        FMDBManager.share().executeDBSQLArr(["create table if not exists \(SearchHistoryDBName) (name varchar(100), width varchar(20), saveTime varchar(20))"])
    }
    
    func tapAction() -> Void {
        if self.selectBlock != nil {
            self.selectBlock!("")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSearchHistoryData() -> Void {
        dataArr = FMDBManager.share().getDBData(withSQL: "select distinct name,width from \(SearchHistoryDBName) order by saveTime DESC limit 0,10").copy() as! [[String:String]]
        collectionView.reloadData()
    }

    func show() -> Void {
        
        getSearchHistoryData()
        
        self.alpha = 1.0
        
        let x = self.frame.origin.x
        let y = self.frame.origin.y
        let wid = self.frame.size.width
        let hei = self.frame.size.height
        
        UIView.animate(withDuration: 0.5) { 
            self.frame = CGRect(x: x+kScreenW/3, y: y, width: wid, height: hei)
            self.frame = CGRect(x: x+kScreenW*2/3, y: y, width: wid, height: hei)
            self.frame = CGRect(x: x+kScreenW, y: y, width: wid, height: hei)
        }
        
    }
    
    func hid() -> Void {
        
        let x = self.frame.origin.x
        let y = self.frame.origin.y
        let wid = self.frame.size.width
        let hei = self.frame.size.height
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.frame = CGRect(x: x-kScreenW/3, y: y, width: wid, height: hei)
            self.frame = CGRect(x: x-kScreenW*2/3, y: y, width: wid, height: hei)
            self.frame = CGRect(x: x-kScreenW, y: y, width: wid, height: hei)
        }) { (completion) in
            self.alpha = 0.0
        }
    }
}

extension SearchHistoryView {
    // MARK: -- <#Value#>
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self.collectionView {
            return false
        }else {
            return true
        }
    }
    // MARK: -- UICollectionViewDataSource/UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCellID, for: indexPath) as! SearchHistoryCollectionViewCell
        let width: Float = Float(dataArr[indexPath.row]["width"]!)!
        cell.label.frame = CGRect(x: 0, y: 0, width: CGFloat(width), height: HEI)
        cell.label.text = dataArr[indexPath.row]["name"]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectBlock != nil {
            self.selectBlock!(dataArr[indexPath.row]["name"]!)
        }
    }
    // MARK: -- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: Float = Float(dataArr[indexPath.row]["width"]!)!
        
        return CGSize(width: CGFloat(width), height: HEI)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenW, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchHistoryHeaderID, for: indexPath) as! SearchHistoryHeaderCollectionReusableView
        header.deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        return header
    }
    
    func deleteBtnAction() -> Void {
        _ = UIAlertController.showAction(target: getCurrentVC(), alertAction1: UIAlertAction.init(title: "取消", style: .cancel, handler: nil), alertAction2: UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            
            FMDBManager.share().deleteDBData(from: SearchHistoryDBName)
            self.dataArr = []
            self.collectionView.reloadData()
            
        }), message: "是否清空历史记录?")
    }
    
}

class SearchHistoryLayout: UICollectionViewFlowLayout {
    
    var maximumSpacing: NSInteger?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arr = super.layoutAttributesForElements(in: rect)
        
        //有个header
        if arr?.count == 1 {
            return arr
        }
        
        for i in 1..<arr!.count {
            
            let current = arr?[i]
            let last = arr?[i-1]
            
            let space: NSInteger = self.maximumSpacing ?? 15
            
            let current_maxX = current?.frame.maxX
            let last_maxX = last?.frame.maxX
            
            if current_maxX! > last_maxX! && (last_maxX! + CGFloat(space) + current!.frame.size.width) < self.collectionViewContentSize.width  {
                var frame = current!.frame
                frame.origin.x = last_maxX! + CGFloat(space)
                current?.frame = frame
            }
            
        }
        return arr
    }
    
}

class SearchHistoryCollectionViewCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SearchHistoryHeaderCollectionReusableView: UICollectionReusableView {
    
    var label = UILabel()
    
    var deleteBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: 10, y: 0, width: kScreenW/2, height: 44))
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.lightGray
        label.text = "搜索历史"
        addSubview(label)
        
        deleteBtn = UIButton(frame: CGRect(x: kScreenW-44, y: 0, width: 44, height: 44))
        deleteBtn.sizeToFit()
        deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        deleteBtn.setImage(UIImage(named:"hml_history_delete"), for: .normal)
        deleteBtn.setImage(UIImage(named:"hml_history_delete"), for: .selected)
        addSubview(deleteBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
