//
//  ShopCartVCTableCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 11/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit


typealias ShopCartClosure = (_ cellID:Int) ->Void


//MARK: --- 可以在每个cell的增减按钮上面添加一个删除和收藏按钮
protocol ShopCartVCTableCellDelegate {
    func numberButtonResult(_ numberButton: PPNumberButton, number: String, cellID:Int)
    
    func deleteItemAction(cellID:Int)
    
}



class ShopCartVCTableCell: UITableViewCell {

    var addClosure:ShopCartClosure?
    var reduceClosure:ShopCartClosure?
    var delegate:ShopCartVCTableCellDelegate?
    
    //Mark: --- 删除按钮闭包回调
    var deleteItemClousure:ShopCartClosure?
    
    
    
    var cellID:Int = 0
    
    var type:GoodsControlType = .plusOrReduce {
        didSet {
            self.setType(type: type)
        }
    }
    
    var isChecked:Bool? {
        didSet {
            if let isChecked = isChecked {
                if isChecked {
                    checkBoxBtn.setImage(UIImage.init(named: "hlm_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    if let addClosure = addClosure {
                        addClosure(cellID)
                    }
                } else {
                    checkBoxBtn.setImage(UIImage.init(named: "hlm_disSelected")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    if let reduceClosure = reduceClosure {
                        reduceClosure(cellID)
                    }
                }
            }
        }
    }
    
    var model:ShopCartGoodModel? {
        didSet{
            let goodsControlModel = GoodsControlModel.init(dict: ["avtarImage":model!.avtarImage, "title":model!.name, "price":model!.price, "count":model!.count])
            goodsControlView.model = goodsControlModel
        }
    }
    
    lazy var checkBoxBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .system)
        btn.setImage(UIImage.init(named: "hlm_disSelected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(ShopCartVCTableCell.changeState), for: .touchUpInside)
        return btn
    }()
    
    lazy var goodsControlView:GoodsControlView = { [weak self]  in
        let rect = CGRect.zero
        let view = GoodsControlView.init(frame: rect, type: .plusOrReduce)
        return view
    }()
    
    lazy var sepView = {() -> UIView in
        let view = UIView.init()
        view.backgroundColor = UIColor.init(gray: 249)
        return view
    }()

    
    
    func setType(type:GoodsControlType) {
        /*
        goodsControlView.removeFromSuperview()
        goodsControlView = GoodsControlView.init(frame: CGRect.zero, type: type)
        goodsControlView.delegate = self
        self.addSubview(goodsControlView)
         */
        switch type {
        case .delete:
            self.goodsControlView.deleteBtn.alpha = 1
        default:
            self.goodsControlView.deleteBtn.alpha = 0
        }
    }
    
    
    func changeState() {
        if let isChecked = isChecked {
            self.isChecked = !isChecked
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isChecked = false
        self.contentView.addSubview(checkBoxBtn)
        self.contentView.addSubview(goodsControlView)
        goodsControlView.delegate = self
        self.contentView.addSubview(sepView)
        self.addObserver(self, forKeyPath: "isChecked", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        checkBoxBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        goodsControlView.snp.makeConstraints { (make) in
            make.left.equalTo(checkBoxBtn.snp.right).offset(0)
            make.top.equalToSuperview()
            make.bottom.equalTo(sepView.snp.top)
            make.right.equalToSuperview()
        }
        
        sepView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(goodsControlView.snp.bottom)
            make.height.greaterThanOrEqualTo(10)
            make.bottom.equalToSuperview()
        }
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
       
    }
    
    
}



extension ShopCartVCTableCell:GoodsControlViewDelegate {
    func numberButtonResult(_ numberButton: PPNumberButton, number: String) {
        if let delegate = delegate {
            delegate.numberButtonResult(numberButton, number: number, cellID: cellID)
        }
    }
    
    func deleteItemAction() {
        if let delegate = delegate {
            delegate.deleteItemAction(cellID: cellID)
        }
    }
}
