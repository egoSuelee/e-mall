//
//  WalletRecordTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class WalletRecordTCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var date1Label: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    fileprivate var grayView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(gray: 231)
        return view
    }()
    
    var dataDic: [String:String]? {
        didSet{
            let date = self.getDateStr(dateStr: dataDic!["date"]!)
            self.dateLabel.text = date.date
            self.date1Label.text = date.date1
            if dataDic!["moneyState"] == "1" {
                self.moneyLabel.text = "+" + dataDic!["money"]!
                self.detailLabel.text = "由" + dataDic!["id"]! + "转入"
            }else{
                self.moneyLabel.text = "-" + dataDic!["money"]!
                self.detailLabel.text = "向" + dataDic!["id"]! + "付款"
            }
        }
    }
    
    func getDateStr(dateStr: String) -> (date: String,date1: String) {
        
        let dateStr1 = dateStr.substring(to: dateStr.index(dateStr.startIndex, offsetBy: 18))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "GMT")
        
        let date = formatter.date(from: dateStr1)
        let date1 = Date()
        
        let calendar = Calendar.current
        let dateCom = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: date!, to: date1)
        
        switch dateCom {
        case DateComponents.init(year: 0, month: 0, day: 0):
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "HH:mm"
            formatter1.locale = Locale(identifier: "en_US")
            formatter1.timeZone = TimeZone(identifier: "GMT")
            return ("今天",formatter1.string(from: date!))
        case DateComponents.init(year: 0, month: 0, day: 1):
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "HH:mm"
            formatter1.locale = Locale(identifier: "en_US")
            formatter1.timeZone = TimeZone(identifier: "GMT")
            return ("昨天",formatter1.string(from: date!))
        default:
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "EEEE"
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "MM-dd"
            return (formatter1.string(from: date!),formatter2.string(from: date!))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dateLabel.font = UIFont.systemFont(ofSize: 17)
        self.date1Label.font = UIFont.systemFont(ofSize: 17)
        self.moneyLabel.font = UIFont.systemFont(ofSize: 20)
        self.detailLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.grayView.frame = CGRect(x: WID, y: 69, width: WID*19, height: 1)
        self.contentView.addSubview(self.grayView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
