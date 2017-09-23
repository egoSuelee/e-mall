//
//  CustomPopAnim.swift
//  CustomView
//
//  Created by @xwy_brh on 24/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class CustomPopAnim: NSObject {
    
    var frame:CGRect = CGRect.zero
    
    init(frame:CGRect) {
        super.init()
        self.frame = frame
    }
    
}

extension CustomPopAnim:UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.7
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC     = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let containerView: UIView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        
        var newFrame = frame
        newFrame.origin.x += 3
        newFrame.origin.y += 4
        
        
        let startCircle: UIBezierPath = UIBezierPath(ovalIn: newFrame)
        
        var maxRadiusX = kScreenW - (frame.origin.x + frame.size.width/2)
        maxRadiusX = maxRadiusX > (frame.origin.x + frame.size.width/2) ? maxRadiusX : (frame.origin.x + frame.size.width/2)
        
        var maxRadiusY = kScreenH - (frame.origin.y + frame.size.height/2)
        maxRadiusY = maxRadiusY > (frame.origin.y + frame.size.height/2) ? maxRadiusY : (frame.origin.y + frame.size.height/2)
        
        let radius: CGFloat = sqrt(pow(maxRadiusX, 2) + pow(maxRadiusY, 2))
        
        let centerPoint = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
        
        let endCircle: UIBezierPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat(2)*CGFloat.pi, clockwise: true)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = startCircle.cgPath
        fromVC.view.layer.mask = maskLayer
        
        let maskLayerAnimation: CABasicAnimation = CABasicAnimation()
        
        maskLayerAnimation.fromValue = endCircle.cgPath
        maskLayerAnimation.toValue   = startCircle.cgPath
        maskLayerAnimation.duration  = transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayerAnimation.setValue(transitionContext, forKey: "transitionContextPop")
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
}

extension CustomPopAnim:CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let transitionContext: UIViewControllerContextTransitioning = anim.value(forKey: "transitionContextPop") as! UIViewControllerContextTransitioning
        transitionContext.completeTransition(true)
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
    }
}
