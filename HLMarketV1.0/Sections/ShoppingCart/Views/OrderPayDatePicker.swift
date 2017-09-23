//
//  OrderPayDatePicker.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/24.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

typealias DatePickerBlock = (_ isCorrect: Bool, _ date1: String, _ date2: String) -> ()

struct DatePickerStr {
    var hour: Int = 0
    var minute: Int = 0
    var dataArr1: [String]
    var dataArr2: [String]
    func time() -> String {
        return dataArr1[hour] + ":" + dataArr2[minute]
    }
    func isMinCompareTo(pickerStr: DatePickerStr) -> Bool {
        switch (self,pickerStr) {
        case let (a,b) where a.hour == b.hour && a.minute < b.minute:
            return true
        case let (a,b) where a.hour == b.hour && a.minute >= b.minute:
            return false
        case let (a,b) :
            return a.hour < b.hour
        }
    }
    
    mutating func isMinCompareTo1(pickerStr: inout DatePickerStr, type: Bool) -> Void {
        
        let result:(Int,Int)?
        
        switch (self,pickerStr) {
        case let (a,b) where a.hour == b.hour && a.minute >= b.minute:
            if type {
                if a.minute == 0 {
                    result = (0,1)
                }else{
                    result = (1,0)
                }
            }else{
                if b.minute == 0 {
                    result = (-1,1)
                }else{
                    result = (0,0)
                }
            }
        case let (a,b) where a.hour > b.hour:
            if type {
                if a.minute == 0 {
                    result = (0,1)
                }else{
                    result = (1,0)
                }
            }else{
                if b.minute == 0 {
                    result = (-1,1)
                }else{
                    result = (0,0)
                }
            }
        default:
            result = nil
        }
        
        guard let result1 = result else {
            return
        }
        
        if type {
            pickerStr.hour = self.hour + result1.0
            pickerStr.minute = result1.1
        }else{
            self.hour = pickerStr.hour + result1.0
            self.minute = result1.1
        }
        
    }

    subscript (index: Int) -> Int{
        get{
            if index == 0{
                return self.hour
            }else{
                return self.minute
            }
        }
        set{
            if index == 0{
                self.hour = newValue
            }else{
                self.minute = newValue
            }
        }
    }
}

class OrderPayDatePicker: UIView {
    
    fileprivate var dateMoveView = UIView()
    fileprivate var datePicker1 = UIPickerView()
    fileprivate var datePicker2 = UIPickerView()
    fileprivate var datePikerTag = ""
    fileprivate var superTarget: UIView?
    fileprivate var dataArr1 = [String]()
    fileprivate var dataArr2 = [String]()
    fileprivate var datePickerStr1: DatePickerStr?
    fileprivate var datePickerStr2: DatePickerStr?
    var datePickerBlock: DatePickerBlock?
    
    init(target: UIView, frame: CGRect) {
        super.init(frame: frame)
        
        getDateData()
        
        superTarget = target
        alpha = 0.0
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        dateMoveView = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height/3+44+10))
        dateMoveView.backgroundColor = UIColor.white
        addSubview(dateMoveView)
        
        let label = UILabel(frame: CGRect(x: WID, y: 5, width: WID*12, height: 44))
        label.text = "温馨提示:17点之前下单明天配送,17点之后下单后天配送!"
        label.textColor = UIColor.red
        label.font = font(14);
        label.numberOfLines = 2;
        dateMoveView.addSubview(label);
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: WID*14.5, y: 5, width: WID*4, height: 44)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.appMainColor()
        btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        dateMoveView.addSubview(btn)
        
        let datePickerlabel = UILabel(frame: CGRect(x: WID, y: btn.frame.maxY+5, width: dateMoveView.frame.width-WID*2, height: 44))
        datePickerlabel.text = "请选择时间间隔:"
        datePickerlabel.textAlignment = .center
        datePickerlabel.textColor = UIColor.appMainColor()
        datePickerlabel.font = font(14);
        dateMoveView.addSubview(datePickerlabel);
        
        datePicker1 = UIPickerView(frame: CGRect(x: WID, y: datePickerlabel.frame.maxY+5, width: (dateMoveView.frame.width-WID*3)/2, height: dateMoveView.frame.height-(datePickerlabel.frame.maxY+10)))
        datePicker1.delegate = self
        datePicker1.dataSource = self
        datePicker1.backgroundColor = UIColor.white
        datePicker1.layer.borderColor = UIColor.appMainColor().cgColor
        datePicker1.layer.borderWidth = 1
        dateMoveView.addSubview(datePicker1)
        
        
        datePicker2 = UIPickerView(frame: CGRect(x: datePicker1.frame.maxX+WID, y: datePickerlabel.frame.maxY+5, width: (dateMoveView.frame.width-WID*3)/2, height: dateMoveView.frame.height-(datePickerlabel.frame.maxY+10)))
        datePicker2.delegate = self
        datePicker2.dataSource = self
        datePicker2.backgroundColor = UIColor.white
        datePicker2.layer.borderColor = UIColor.appMainColor().cgColor
        datePicker2.layer.borderWidth = 1
        dateMoveView.addSubview(datePicker2)
        
        datePicker2.selectRow(1, inComponent: 1, animated: true)
        
    }
    // MARK: -- 按钮点击事件
    func btnAction(btn: UIButton) -> Void {
        
        hideDatePicker()
        
        var isCorrect = true
        
        if datePickerStr1!.isMinCompareTo(pickerStr: datePickerStr2!) == false {
            isCorrect = false
        }
        
        if self.datePickerBlock != nil  {
            self.datePickerBlock!(isCorrect,datePickerStr1!.time(),datePickerStr2!.time())
        }
        
    }
    func getDateData() -> Void {
        
        for i in 9...17 {
            var str = "\(i)"
            if i<10 {
                str = "0" + str
            }
            dataArr1.append(str)
        }
        dataArr2 = ["00","30"]
        datePickerStr1 =  DatePickerStr(hour: 0, minute: 0, dataArr1: dataArr1, dataArr2: dataArr2)
        datePickerStr2 =  DatePickerStr(hour: 0, minute: 1, dataArr1: dataArr1, dataArr2: dataArr2)
    }
    // MARK: -- 显示DatePicker
    func showDatePickerWithStartTime(tag: String = "DatePicker") -> Void {
        
        datePikerTag = tag
        
        if let target: UIView = superTarget {
            target.bringSubview(toFront: self)
        }
        alpha = 1.0
        
        let y = dateMoveView.frame.origin.y
        
        UIView.animate(withDuration: 0.5) {
            self.dateMoveView.frame = CGRect(x: 0, y: y-(self.frame.size.height/3+44+10)/3, width: self.frame.size.width, height: self.frame.size.height/3+44+10)
            self.dateMoveView.frame = CGRect(x: 0, y: y-(self.frame.size.height/3+44+10)*2/3, width: self.frame.size.width, height: self.frame.size.height/3+44+10)
            self.dateMoveView.frame = CGRect(x: 0, y: y-(self.frame.size.height/3+44+10), width: self.frame.size.width, height: self.frame.size.height/3+44+10)
        }
        
    }
    // MARK: -- 隐藏DatePicker
    func hideDatePicker() -> Void {
        let y = dateMoveView.frame.origin.y
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dateMoveView.frame = CGRect(x: 0, y: y+(self.frame.size.height/3+44+10)/3, width: self.frame.size.width, height: self.frame.size.height/3+44+10)
            self.dateMoveView.frame = CGRect(x: 0, y: y+(self.frame.size.height/3+44+10)*2/3, width: self.frame.size.width, height: self.frame.size.height/3+44+10)
            self.dateMoveView.frame = CGRect(x: 0, y: y+(self.frame.size.height/3+44+10), width: self.frame.size.width, height: self.frame.size.height/3+44+10)
        }) { (finished) in
            self.alpha = 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OrderPayDatePicker: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.dataArr1.count
        case 1:
            return self.dataArr2.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return self.dataArr1[row]
        case 1:
            return self.dataArr2[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch (pickerView,component,row) {
        case (datePicker1,component,row):
            datePickerStr1?[component] = row
            if datePickerStr1?.hour == self.dataArr1.count-1 && datePickerStr1?.minute == 1 {
                datePickerStr1?.minute = 0
                datePickerStr2?.hour = self.dataArr1.count-1
                datePickerStr2?.minute = 1
                datePicker2.selectRow(datePickerStr2!.hour, inComponent: 0, animated: true)
                datePicker2.selectRow(datePickerStr2!.minute, inComponent: 1, animated: true)
                datePicker1.selectRow(datePickerStr1!.minute, inComponent: 1, animated: true)
                return
            }
        case (datePicker2,component,row):
            datePickerStr2?[component] = row
            if datePickerStr2?.hour == 0 && datePickerStr2?.minute == 0 {
                datePickerStr2?.minute = 1
                datePickerStr1?.hour = 0
                datePickerStr1?.minute = 0
                datePicker1.selectRow(datePickerStr1!.hour, inComponent: 0, animated: true)
                datePicker1.selectRow(datePickerStr1!.minute, inComponent: 1, animated: true)
                datePicker2.selectRow(datePickerStr2!.minute, inComponent: 1, animated: true)
                return
            }
        default:
            break
        }
        
        changeValue(pickerView: pickerView)
        
    }
    // MARK: -- 检测起始时间比结束时间小
    func changeValue(pickerView: UIPickerView) -> Void {
        
        switch pickerView {
        case datePicker1:
            datePickerStr1!.isMinCompareTo1(pickerStr: &datePickerStr2!, type: true)
            datePicker2.selectRow(datePickerStr2!.hour, inComponent: 0, animated: true)
            datePicker2.selectRow(datePickerStr2!.minute, inComponent: 1, animated: true)
        case datePicker2:
            datePickerStr1!.isMinCompareTo1(pickerStr: &datePickerStr2!, type: false)
            datePicker1.selectRow(datePickerStr1!.hour, inComponent: 0, animated: true)
            datePicker1.selectRow(datePickerStr1!.minute, inComponent: 1, animated: true)
        default:
            break
        }
    }
    
}

