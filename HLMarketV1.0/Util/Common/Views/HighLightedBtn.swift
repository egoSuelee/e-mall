//
//  HighLightedBtn.swift
//  eUtils
//
//  Created by @xwy_brh on 2017/8/15.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class HighLightedBtn: UIButton {
    
    var bgHex:UInt32?
    
    init(frame: CGRect, _ bgHex:UInt32?) {
        super.init(frame: frame)
        if let bgHex = bgHex {
            self.bgHex = bgHex
            self.backgroundColor = UIColor.colorFromHex(bgHex)
            self.addObserver(self, forKeyPath: "highlighted", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let btn = object as! HighLightedBtn
        guard let keyPath = keyPath else {
            return
        }
        if keyPath.isEqual("highlighted") {
            if btn.isHighlighted {
                self.backgroundColor = UIColor.deepColorWith(self.bgHex!)
            } else {
                self.backgroundColor = UIColor.colorFromHex(self.bgHex!)
            }
        }
    }

    deinit {
        self.removeObserver(self, forKeyPath: "highlighted")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
