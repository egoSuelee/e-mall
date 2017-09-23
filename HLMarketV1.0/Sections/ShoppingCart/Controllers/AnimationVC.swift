//
//  AnimationVC.swift
//  HLMarketV1.0
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class AnimationVC: BaseViewController {

    var transitionLayer:CALayer?
    
    //MARK: -- 商品添加至购物车动画
    
    func addProductAnimation(_ imageView:UIImageView) {
        
        
        let myWindow : UIView = ((UIApplication.shared.delegate?.window)!)!
        //MARK: -- 赋值图像内容至当前layer图层
        let frame = imageView.convert(imageView.bounds, to: myWindow)
        
        transitionLayer = CALayer()
        transitionLayer?.frame = frame
        
        transitionLayer?.contentsGravity = kCAGravityResize
        transitionLayer?.contents = imageView.layer.contents
        self.view.layer.addSublayer(transitionLayer!)
      
        
        
        //MARK: -- 位移动画
            //MARK: -- 1 创建路径
        
        let path:UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x:frame.origin.x,  y:frame.origin.y))
        let finishPoint = CGPoint(x:self.view.frame.size.width/4*3-self.view.frame.size.width/8 ,  y:self.view.frame.size.height-49)
        
            //MARK: -- 创建关键帧动画, 将路径添加至关键帧动画里
        path.addQuadCurve(to: finishPoint, controlPoint:CGPoint(x: self.view.frame.size.width/2, y: frame.origin.y - 40))
        
        let pathAnimation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        //位置的平移
        pathAnimation.path = path.cgPath

       
        
        //MARK: -- 缩放动画
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            //定义关键帧
        let scale1 = CATransform3DMakeScale(1.0, 1.0, 1)
        let scale2 = CATransform3DMakeScale(0.65, 0.65, 1)
        let scale3 = CATransform3DMakeScale(0.4, 0.4, 1)
        let scale4 = CATransform3DMakeScale(0.1, 0.1, 1)
        
        let frameValues = [NSValue(caTransform3D:scale1), NSValue(caTransform3D:scale2), NSValue(caTransform3D:scale3), NSValue(caTransform3D:scale4)]
            //添加关键帧到动画中
        scaleAnimation.values = frameValues
        
        let keytimes = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.5),NSNumber.init(value: 0.8),NSNumber.init(value: 1.0)]
        scaleAnimation.keyTimes = keytimes
        scaleAnimation.duration = 0.8
        scaleAnimation.isRemovedOnCompletion = true
        //scaleAnimation.fillMode = kCAFillModeForwards
        
        //MARK: -- 旋转动画
        let rotationBasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationBasicAnimation.isRemovedOnCompletion = true
        rotationBasicAnimation.fromValue = NSNumber(value: 0)
        rotationBasicAnimation.toValue = NSNumber(value: 1 * 2 * Double.pi)
        rotationBasicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        
        //MARK: -- 组合动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [pathAnimation,scaleAnimation,rotationBasicAnimation]
        
        groupAnimation.duration = 0.8
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.delegate = self
        transitionLayer?.add(groupAnimation, forKey: "addProduct")
    }
    
}

extension AnimationVC:CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == transitionLayer!.animation(forKey: "addProduct") {
            transitionLayer?.removeFromSuperlayer()
            transitionLayer = nil
        }
    }
}


















