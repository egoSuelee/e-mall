//
//  DropMenu.swift
//  DropMenu
//
//  Created by @xwy_brh on 2017/8/2.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

fileprivate let kDropDownMeunCellID = "kDropDownBoxCellID"
fileprivate let tableWeight:CGFloat = 1

protocol DropMenuDelegate {
    func dropMeunDidSelectRow(row: Int) -> Void
}

enum DropMenuState {
    case open
    case close
}

fileprivate let kDropMeunCellID = "kDropDownBoxCellID"
let kDropMenuAnimDur:TimeInterval = 0.65

class DropMenu: UIView {
    
    var dataArr:[ClassifyTypeModel]?{
        didSet{
            guard dataArr != nil else {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    var selectedIdx:Int? {
        didSet {
            guard selectedIdx != nil else {
                return
            }
            self.tableView.reloadData()
        }
    }
    var delegate: DropMenuDelegate?
    var state:DropMenuState?
    fileprivate lazy var tableView: UITableView =  { [weak self] in
        let height = self!.frame.size.height * tableWeight
        let rect = CGRect(x: 0, y: 0, width: self!.frame.size.width, height: height)
        
        let tableView = UITableView(frame: rect, style: UITableViewStyle.plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropMenuTableCell.self, forCellReuseIdentifier: kDropMeunCellID)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
        }()
    
    lazy var maskBCView: UIView = {
        let height = kScreenH * 0.4 + 1
        let margin_top = kScreenH * 0.6 - 1
        let view = UIView.init(frame: CGRect.init(x: 0, y: margin_top, width: self.frame.size.width, height: height))
        view.backgroundColor = UIColor.black
        view.alpha = 0
        view.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    func tapAction() {
        showOrHideMenu(isShow: false)
    }
    
    
     init(frame: CGRect,  target: UIView) {
        super.init(frame: frame)
        target.addSubview(self)
        target.addSubview(maskBCView)
        selectedIdx = 0
        self.addSubview(tableView)
        self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        self.layer.position = CGPoint.init(x: (frame.origin.x + frame.size.width)*0.5, y: frame.origin.y)
        self.transform = CGAffineTransform.init(scaleX: 1, y: 0.001)
        self.state = DropMenuState.close
    }
    
    func showOrHideMenu(isShow: Bool) -> Void {
        UIView.animate(withDuration: 0.3) {
            if isShow {
                self.state = .open
                self.alpha = 1
                self.maskBCView.alpha = 0.2
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            }else{
                self.state = .close
                self.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
                self.alpha = 1
                self.maskBCView.alpha = 0
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DropMenu:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDropMeunCellID) as! DropMenuTableCell
        let model = self.dataArr?[indexPath.row]
        cell.titleLabel.text = model?.cCategoryAlias
        if let idx = selectedIdx {
            if idx == indexPath.row {
                cell.state = DropMenuTableCellState.selected
            } else {
                cell.state = DropMenuTableCellState.disSelected
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let delegate = delegate else {
            return
        }
        delegate.dropMeunDidSelectRow(row: indexPath.row)
    }
}

enum DropMenuTableCellState {
    case selected
    case disSelected
}

class DropMenuTableCell:UITableViewCell {
    
    var state:DropMenuTableCellState? {
        didSet {
            guard  let state = state else {
                return
            }
            switch state {
            case .selected:
                titleLabel.textColor = UIColor.appTextMainColor()
                selectedIcon.alpha = 1
            default:
                titleLabel.textColor = UIColor.appNavBarTitleColor()
                selectedIcon.alpha = 0
            }
        }
    }
    
    lazy var titleLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        return label
    }()
    lazy var selectedIcon:UIImageView = {[weak self] in
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "duihao_selected")
        imageView.contentMode = .scaleAspectFill
        return imageView
        }()
    lazy var sepLine:UIView = {[weak self] in
        let view = UIView.init()
        view.backgroundColor = UIColor.colorFromHex(0xececec)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(selectedIcon)
        self.contentView.addSubview(sepLine)
    }
    
    override func layoutSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-_1pxWidth)
            make.width.lessThanOrEqualToSuperview()
        }
        selectedIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(20)
        }
        sepLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(_1pxWidth)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}








