//
//  WalletRechargeVC.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/8/3.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

//layout上下距离
let LAYOUT_LEFTORRIGHT_WIDTH : CGFloat = (kScreenW-TABlE_ARROW_HEIGHT)/10 + TABlE_ARROW_HEIGHT/2
let TABlE_ARROW_HEIGHT : CGFloat = kScreenW * 0.6 * 0.08 * 0.9 + 15
let CELL_WIDTH : CGFloat = (kScreenW-TABlE_ARROW_HEIGHT)*4/5
let CELL_HEIGHT : CGFloat = CELL_WIDTH*0.6

class WalletRechargeVC: BaseViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var cartTableView: UICollectionView!
    
    @IBOutlet weak var rechargeBtn: UIButton!
    
    fileprivate var data = [RechargeStrategy]()
    
    fileprivate var currentIndexRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "乐家优鲜会员"
        
        if let userIcon = UserAuthManager.sharedManager.getUserModel()?.UserIcon {
            userImageView.kf.setImage(with: URL.init(string: DefaultURL + "/Simple_online/" + userIcon) as Resource?, placeholder: UIImage.init(named: "头像"),options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(1)), KingfisherOptionsInfoItem.forceRefresh], progressBlock: nil, completionHandler: nil)
        } else {
            userImageView.image = UIImage.init(named: "头像")
        }
        userImageView.layer.cornerRadius = 30
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
        let model = UserAuthManager.sharedManager.getUserModel()
        if model?.UserNo == "" {
            userNameLabel.text = "暂无昵称"
        } else {
            userNameLabel.text = model!.UserNo
        }
        
        rechargeBtn.layer.borderColor = UIColor.appMainColor().cgColor
        rechargeBtn.layer.borderWidth = 1
        rechargeBtn.layer.cornerRadius = 22
        
        let layout = CDFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.sectionInset = UIEdgeInsetsMake(0, LAYOUT_LEFTORRIGHT_WIDTH, 0, LAYOUT_LEFTORRIGHT_WIDTH)
        layout.itemSize = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
        
        cartTableView.collectionViewLayout = layout
        cartTableView.backgroundColor = UIColor.clear
        cartTableView.showsHorizontalScrollIndicator = false
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(CDViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CDViewCell.self))
        
        requestForRechargeStrategy()
    }
    

    @IBAction func rechargeBtnAction(_ sender: Any) {
        
        guard self.data.count != 0 else {
            return
        }
        
        let  vc = RechargeMoneyVC()
        vc.model = self.data[currentIndexRow]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestForRechargeStrategy() {
        AlamofireNetWork.required(urlString: "/Simple_online/Wallet_recharge_strategy", method: .post, parameters: ["cStoreNo":UserStoreManager.sharedManager.getStoreNo()], success: { (result) in
            let json = JSON(result)
            
            if json["resultStatus"] == "1" {
                let arr =  json["dDate"].arrayObject
                var tmpArr = [RechargeStrategy]()
                for dic in arr! {
                    let dic = dic as! [String:String]
                    let model = RechargeStrategy()
                    model.excess_Money = dic["excess_Money"]
                    model.pay_Money = dic["Pay_Money"]
                    tmpArr.append(model)
                }
                self.data = tmpArr
                self.cartTableView.reloadData()
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WalletRechargeVC : UICollectionViewDelegate , UICollectionViewDataSource{
    //UICollectionView代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cartTableView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CDViewCell.self), for: indexPath) as! CDViewCell
        let model = self.data[indexPath.row]
        cell.titleLabel.text = "冲 \(model.pay_Money!)元 送 \(model.excess_Money!)元"
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //center是collectionView的frame的中心点 pInView是中心点对应到collectionVIew的contentView的坐标
        let pInView = self.view.convert(self.cartTableView.center, to: self.cartTableView)
        let indexPathNow = self.cartTableView.indexPathForItem(at: pInView)!
        self.currentIndexRow = indexPathNow.row
    }
    
}

class RechargeStrategy:NSObject {
    var excess_Money:String? {
        didSet {
            if let money = excess_Money {
                let f = (money as NSString).integerValue
                excess_Money = String(format: "%d", f)
            }
        }
    }
    var pay_Money:String? {
        didSet {
            if let money = pay_Money {
                let f = (money as NSString).integerValue
                pay_Money = String(format: "%d", f)
            }
        }
    }
    override init() {
        super.init()
    }
    
    init(excess_Money: String, pay_Money: String) {
        self.excess_Money = excess_Money
        self.pay_Money = pay_Money
    }
}
