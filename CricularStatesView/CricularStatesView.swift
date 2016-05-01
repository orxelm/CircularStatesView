//
//  CricularStatesView.swift
//  CricularStatesView
//
//  Created by Or Elmaliah on 01/05/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

public class CricularStatesView: UIView {
    
    // MARK: - Properties (Public)
    
    public var numberOfStates: Int = 4 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    public var circleColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    public var circleBorderColor = UIColor.grayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var circleBorderWidth: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var seperatorLength: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var seperatorColor = UIColor.grayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var seperatorWidth: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Properties (Private)
    
    private var diameter: CGFloat = 0
    private var radius: CGFloat {
        return self.diameter / 2.0
    }
    private let margin: CGFloat = 8
    
    // MARK: - UIView
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        print("Bounds: \(self.bounds)")
        
        for index in 0..<self.numberOfStates {
            let centerX = self.margin + self.radius
            let centerY = self.radius + CGFloat(index) * (self.diameter + self.seperatorLength) + self.margin
            let circularPath = UIBezierPath.circlePathWithCenter(CGPoint(x: centerX, y: centerY), diameter: self.diameter, borderWidth: self.circleBorderWidth)
            
            self.circleColor.setFill()
            self.circleBorderColor.setStroke()
            circularPath.fill()
            circularPath.stroke()
            
            if index != self.numberOfStates.predecessor() {
                let linePath = UIBezierPath()
                linePath.moveToPoint(CGPoint(x: centerX, y: centerY+self.radius))
                linePath.addLineToPoint(CGPoint(x: centerX, y: centerY+self.radius+self.seperatorLength))
                linePath.lineWidth = self.seperatorWidth
                
                self.seperatorColor.setStroke()
                linePath.stroke()
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.calculateCircleDiameter()
        self.setNeedsDisplay()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Calculations
    
    private func calculateCircleDiameter() {
        let height = CGRectGetHeight(self.bounds)
        let count = CGFloat(self.numberOfStates)
        let numOfseperators = count - 1
        
        let heightWithoutSeperatorsAndMargins = height - (numOfseperators * self.seperatorLength) - 2.0 * self.margin
        let diameter = (heightWithoutSeperatorsAndMargins / count)
        
        self.diameter = diameter
    }
}

extension UIBezierPath {
    class func circlePathWithCenter(center: CGPoint, diameter: CGFloat, borderWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: diameter/2, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise: true)
        path.lineWidth = borderWidth
        return path
    }
}
