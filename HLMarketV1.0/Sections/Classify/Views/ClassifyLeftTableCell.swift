//
//  ClassifyLeftTableCell.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//
import UIKit

class ClassifyLeftTableCell: UITableViewCell {
    
    lazy var line:UIView = {[weak self] in
        let view = UIView.init()
        view.backgroundColor = UIColor.colorFromHex(0xf1f1f1)
        return view
        }()
    
    lazy var marketLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        return label
        }()
    lazy var titleLabel:UILabel = {[weak self] in
        let label = UILabel.init()
        label.textColor = UIColor.colorFromHex(0x6f6f6f)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
        }()
    
    var title:String? {
        didSet {
            guard let title = title else {
                return
            }
            titleLabel.text = title
        }
    }
    
    func setRightLabelText(_ text:String) {
        titleLabel.text = text
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        //定义点击cell时改变cell的颜色
        let cellBgView = UIView.init(frame: self.bounds)
        cellBgView.backgroundColor = UIColor.white
        self.selectedBackgroundView = cellBgView
    }
    
    func setupUI() {
        _ = [line, marketLabel, titleLabel].map {
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(3)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(line.snp.right)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            titleLabel.textColor = UIColor.colorFromHex(0x343434)
            line.backgroundColor = UIColor.appTextMainColor()
            //定义点击cell时改变cell的颜色
            let cellBgView = UIView.init(frame: self.bounds)
            cellBgView.backgroundColor = UIColor.white
            self.selectedBackgroundView = cellBgView
        } else {
            titleLabel.textColor = UIColor.colorFromHex(0x6f6f6f)
            line.backgroundColor = UIColor.init(gray: 242)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

