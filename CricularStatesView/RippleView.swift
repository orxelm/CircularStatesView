//
//  RippleView.swift
//  Brisk
//
//  Created by Or Elmaliah on 19/01/2016.
//  Copyright © 2016 TheNets. All rights reserved.
//

import UIKit

class RippleView: UIView {

    private var timer: NSTimer?
    
    // MARK: NSObject
    
    deinit {
        self.stopTimer()
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.whiteColor().CGColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = frame.size.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    // MARK: Public
    
    func startRippleEffect() {
        self.starTimer()
    }
    
    func stopRippleEffect() {
        self.stopTimer()
    }
    
    // MARK: Timer
    
    private func starTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func timerFired(timer: NSTimer) {
        self.fireRipple()
    }
    
    // MARK: Animation
    
    private func fireRipple() {
        let pathFrame = CGRect(x: -CGRectGetMidX(self.bounds), y: -CGRectGetMidY(self.bounds), width: self.bounds.size.width, height: self.bounds.size.height)
        let path = UIBezierPath(roundedRect: pathFrame, cornerRadius: self.layer.cornerRadius)
        
        let shapePosition = self.convertPoint(self.center, fromView: self.superview)
        
        let circleShape = CAShapeLayer()
        circleShape.path = path.CGPath
        circleShape.position = shapePosition
        circleShape.fillColor = UIColor.clearColor().CGColor
        circleShape.opacity = 0
        circleShape.strokeColor = CSS.briskColor().CGColor
        circleShape.lineWidth = 0.5
        
        self.layer.addSublayer(circleShape)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.5, 1.5, 1))
        scaleAnimation.removedOnCompletion = true
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        alphaAnimation.removedOnCompletion = true
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.removedOnCompletion = true
        circleShape.addAnimation(animation, forKey: nil)
    }
}
