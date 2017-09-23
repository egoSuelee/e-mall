//
//  WalletValueCardTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class WalletValueCardTCell: UITableViewCell {
    
    var code: String? {
        didSet{
            barCodeImageView.image = generateBarCode(code: code!, width: width*16, height: WalletTCellHei*0.6)
            barCodeLabel.text = formatCode(code: code!)
        }
    }
    
    var money: String = "0.00"
    
    var btnState: Bool? {
        didSet{
            if btnState! == true {
                barMoneyIsHideBtn.setImage(#imageLiteral(resourceName: "hlm_walletMoney_see"), for: .normal)
                barMoneyIsHideBtn.setImage(#imageLiteral(resourceName: "hlm_walletMoney_see"), for: .highlighted)
                barMoneyLabel.text = String.init(format: "￥%0.2f", Float(Double(money)!))
            }else{
                barMoneyIsHideBtn.setImage(#imageLiteral(resourceName: "hlm_walletMoney_notsee"), for: .normal)
                barMoneyIsHideBtn.setImage(#imageLiteral(resourceName: "hlm_walletMoney_notsee"), for: .highlighted)
                barMoneyLabel.text = "...."
            }
        }
    }
    
    fileprivate var boxView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
//        view.backgroundColor = UIColor(red: 0.0235, green: 0.8567, blue: 0.776, alpha: 1)
        return view
    }()
    fileprivate var boxImageView: UIImageView = {
        let view = UIImageView()
//        view.layer.cornerRadius = 5
//        view.layer.masksToBounds = true
        view.image = #imageLiteral(resourceName: "hlm_wallet_card1")
        return view
    }()
    fileprivate var barCodeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate var barCodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    fileprivate var barMoneyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var barMoneyIsHideBtn: UIButton = {
        let btn = HLP_MiniImageSizeBtn.image(scale: 0.5)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(boxView)
        boxView.addSubview(boxImageView)
        boxView.addSubview(barCodeImageView)
        boxView.addSubview(barCodeLabel)
        boxView.addSubview(barMoneyLabel)
        boxView.addSubview(barMoneyIsHideBtn)
        
    }
    
    override func layoutSubviews() {
        
        boxView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(WID, WID, 0, WID))
        }
        
        boxImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        barCodeLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.equalToSuperview().offset(-WID)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        barCodeImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-WID)
            make.left.equalToSuperview().offset(WID)
            make.top.equalTo(barCodeLabel.snp.bottom)
            make.bottom.equalTo(barMoneyLabel.snp.top)
        }
        
        barMoneyLabel.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        barMoneyIsHideBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(WID)
            make.height.width.equalTo(barMoneyLabel.snp.height)
        }
        
    }
    // MARK: -- 格式化字符串
    func formatCode(code: String) -> String {
        var chars = ""
        for (i,char) in code.characters.enumerated() {
            chars.append(char)
            if i%4 == 3 {
                chars.append(" ")
            }
        }
       return chars
    }
    // MARK: -- 生成二维码
    func generateBarCode(code: String, width: CGFloat, height: CGFloat) -> UIImage {
        // 生成二维码图片
        let data = code.data(using: .isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let barcodeImage = filter?.outputImage
        // 消除模糊
        let scaleX = width/barcodeImage!.extent.size.width// extent 返回图片的frame
        let scaleY = height/barcodeImage!.extent.size.width
        let transformedImage:CIImage = barcodeImage!.applying(CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY))
        return UIImage(ciImage: transformedImage)
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
