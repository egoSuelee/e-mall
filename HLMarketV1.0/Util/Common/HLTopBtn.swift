//
//  HLDIGOUSWIFT
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

//图片在上方的button
import UIKit

class HLTopBtn: UIButton {

    var margin : CGFloat = 5
    var scale : CGFloat = 0.5
    /**
     图片在上面的Button
     */
    
    init(frame: CGRect, scale: CGFloat = 0.5, margin: CGFloat = 5) {
        super.init(frame: frame)
        self.scale = scale
        self.margin = margin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.HL_centerX = HL_width * 0.5
        imageView?.HL_centerY = HL_height * scale * 0.7
        
        titleLabel?.sizeToFit()
        
        titleLabel?.HL_centerX = HL_width * 0.5
        titleLabel?.HL_y = (imageView?.frame)!.maxY + margin

    }
}
