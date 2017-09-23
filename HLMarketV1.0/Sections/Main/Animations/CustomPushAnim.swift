//
//  CustomPushAnim.swift
//  CustomView
//
//  Created by @xwy_brh on 24/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class CustomPushAnim: NSObject {

}

extension CustomPushAnim:UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.7
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView: UIView = transitionContext.containerView
        var conframe = containerView.frame
        conframe.origin.y += kNavigationBarH + kStatusBarH
        containerView.frame = conframe
        
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        
        let startCircle: UIBezierPath = UIBezierPath(ovalIn: CGRect(x: -(kStatusBarH + kNavigationBarH)/2, y: 0, width: kStatusBarH + kNavigationBarH, height: kStatusBarH + kNavigationBarH))
        
        let radius: CGFloat = sqrt(pow(kScreenW, 2) + pow(kScreenH - kTabBarH, 2))
        
        let endCircle: UIBezierPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = endCircle.cgPath
        toVC.view.layer.mask = maskLayer
        
        let maskLayerAnimation: CABasicAnimation = CABasicAnimation()
        maskLayerAnimation.fromValue = startCircle.cgPath
        maskLayerAnimation.toValue = endCircle.cgPath
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayerAnimation.setValue(transitionContext, forKey: "transitionContext")
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
        
    }
}

extension CustomPushAnim:CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let transitionContext: UIViewControllerContextTransitioning = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning
        transitionContext.completeTransition(true)
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
    }
}
