//
//  CircularIndicatorView.swift
//  CircularStatesView
//
//  Created by Or Elmaliah on 19/01/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

class CircularIndicatorView: UIView {
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shapeInit()
    }
    
    // MARK: - Appearence
    
    private func shapeInit() {
        self.layer.removeAllAnimations()
        
        let width = self.bounds.width
        let startAngle = CGFloat(0.8*2*M_PI)
        let endAngle = startAngle + CGFloat(2*M_PI*0.9)
        let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        var frame = self.bounds
        if frame.width != frame.height {
            let size = min(frame.width, frame.height)
            frame.size.width = size
            frame.size.height = size
        }
        
        let circleShape = CAShapeLayer()
        circleShape.path = path.CGPath
        circleShape.frame = frame
        circleShape.fillColor = UIColor.clearColor().CGColor
        circleShape.strokeColor = UIColor.redColor().CGColor
        circleShape.lineWidth = 1
        
        self.layer.addSublayer(circleShape)
        
        let circleAnimation = CABasicAnimation(keyPath: "transform.rotation")
        circleAnimation.toValue = NSNumber(double: 1*2*M_PI)
        circleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleAnimation.duration = 1.5
        circleAnimation.repeatCount = Float.infinity
        circleAnimation.removedOnCompletion = false
        
        circleShape.addAnimation(circleAnimation, forKey: nil)
    }
}
