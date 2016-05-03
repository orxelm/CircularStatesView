//
//  CircularStatesView.swift
//  CircularStatesView
//
//  Created by Or Elmaliah on 01/05/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

public protocol CircularStatesViewDataSource: class {
    func numberOfStatesInCricularStatesView(cricularStatesView: CircularStatesView) -> Int
    func cricularStatesView(cricularStatesView: CircularStatesView, titleForStateAtIndex index: Int) -> String?
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForActiveStateAtIndex index: Int) -> UIImage?
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForInActiveStateAtIndex index: Int) -> UIImage?
}

public class CircularStatesView: UIView {
    
    // MARK: - Properties (Public)
    
    weak var dataSource: CircularStatesViewDataSource?
    
    /// The number of states in view
    public private(set) var numberOfStates: Int = 0
    
    /// The circle's fill color
    public var circleColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The circle's border color
    public var circleBorderColor = UIColor.grayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The width of the border
    public var circleBorderWidth: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The length of the seperator line between each circle state
    public var seperatorLength: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The line seperator color
    public var seperatorColor = UIColor.grayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The line seperator width
    public var seperatorWidth: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The states title font
    public var stateTitleFont = UIFont.systemFontOfSize(17) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The state title text color
    public var stateTitleTextColor = UIColor.darkTextColor() {
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
        
        for index in 0..<self.statesCount() {
            // State Circle
            let centerX = self.margin + self.radius
            let centerY = self.radius + CGFloat(index) * (self.diameter + self.seperatorLength) + self.margin
            let circularPath = UIBezierPath.circlePathWithCenter(CGPoint(x: centerX, y: centerY), diameter: self.diameter, borderWidth: self.circleBorderWidth)
            
            self.circleColor.setFill()
            self.circleBorderColor.setStroke()
            circularPath.fill()
            circularPath.stroke()
            
            // Image Icon
            let imageIcon = self.dataSource?.cricularStatesView(self, imageIconForActiveStateAtIndex: index)
            let iconWidth = imageIcon?.size.width ?? 0
            let iconHeight = imageIcon?.size.height ?? 0
            imageIcon?.drawAtPoint(CGPoint(x: centerX-(iconWidth/2), y: centerY-(iconHeight/2)))
            
            // Title Label
            let titleLabel = UILabel()
            titleLabel.text = self.dataSource?.cricularStatesView(self, titleForStateAtIndex: index)
            titleLabel.font = self.stateTitleFont
            titleLabel.textColor = self.stateTitleTextColor
            titleLabel.numberOfLines = 0
            let titleWidth = CGRectGetWidth(self.bounds) - (centerX + self.radius + (2 * self.margin))
            let titleHeight = self.diameter - (2 * self.margin)
            titleLabel.frame = CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight)
            titleLabel.drawTextInRect(CGRect(x: centerX + self.radius + self.margin, y: centerY - (titleHeight/2), width: titleLabel.frame.width, height: titleLabel.frame.height))
            
            // Seperator
            if index != self.statesCount().predecessor() {
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
    
    override public init(frame: CGRect) {
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
        let count = CGFloat(self.statesCount())
        if count > 0 {
            let height = CGRectGetHeight(self.bounds)
            let numOfseperators = count - 1
            
            let heightWithoutSeperatorsAndMargins = height - (numOfseperators * self.seperatorLength) - 2*self.margin
            let diameter = (heightWithoutSeperatorsAndMargins / count)
            
            self.diameter = diameter
        }
    }
    
    private func statesCount() -> Int {
        return self.numberOfStates > 0 ? self.numberOfStates : (self.dataSource?.numberOfStatesInCricularStatesView(self) ?? 0)
    }
}

extension UIBezierPath {
    class func circlePathWithCenter(center: CGPoint, diameter: CGFloat, borderWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: diameter/2, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise: true)
        path.lineWidth = borderWidth
        return path
    }
}
