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
    func cricularStatesView(cricularStatesView: CircularStatesView, isStateActiveAtIndex index: Int) -> Bool
    func cricularStatesView(cricularStatesView: CircularStatesView, titleForStateAtIndex index: Int) -> String?
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForActiveStateAtIndex index: Int) -> UIImage?
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForInActiveStateAtIndex index: Int) -> UIImage?
}

public class CircularStatesView: UIView {
    
    // MARK: - Properties (Public)
    
    weak var dataSource: CircularStatesViewDataSource?
    
    /// The number of states in view
    public private(set) var numberOfStates: Int = 0
    
    /// The circle's active state fill color
    public var circleActiveColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The circle's in-active state fill color
    public var circleInactiveColor = UIColor.lightGrayColor() {
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
    
    /// The maximum value for the circle diameter
    public var circleMaxSize: CGFloat? {
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
    
    // MARK: - State Indicators (Private)
    
    private var frameForRippleView: CGRect?
    private var rippleView: RippleView?
    
    // MARK: - NSObject
    
    deinit {
        self.rippleView?.stopRippleEffect()
        self.rippleView = nil
    }
    
    // MARK: - UIView
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let statesCount = self.statesCount()
        for index in 0..<statesCount {
            // State Circle
            let height = CGRectGetHeight(self.bounds)
            let totalMargin = height - (CGFloat(statesCount) * self.diameter + CGFloat(statesCount.predecessor()) * self.seperatorLength)
            let marginFromTop = totalMargin / 2
            
            let centerX = self.margin + self.radius
            let centerY = self.radius + CGFloat(index) * (self.diameter + self.seperatorLength) + marginFromTop
            let circularPath = UIBezierPath.circlePathWithCenter(CGPoint(x: centerX, y: centerY), diameter: self.diameter, borderWidth: self.circleBorderWidth)
            
            let isActive = self.dataSource?.cricularStatesView(self, isStateActiveAtIndex: index)
            var isNextStateActive = false
            if isActive == true {
                self.circleActiveColor.setFill()
            
                if index < statesCount.predecessor() {
                    isNextStateActive = self.dataSource?.cricularStatesView(self, isStateActiveAtIndex: index.successor()) ?? false
                    if isNextStateActive == false {
                        self.frameForRippleView = circularPath.bounds
                        self.updateIndicatorViews()
                    }
                }
            }
            else {
                self.circleInactiveColor.setFill()
            }
            
            self.circleBorderColor.setStroke()
            circularPath.fill()
            circularPath.stroke()
            
            // Image Icon
            let iconImage = isActive == true ? self.dataSource?.cricularStatesView(self, imageIconForActiveStateAtIndex: index) : self.dataSource?.cricularStatesView(self, imageIconForInActiveStateAtIndex: index)
            if let imageIcon = iconImage {
                let iconWidth = imageIcon.size.width
                let iconHeight = imageIcon.size.height
                imageIcon.drawAtPoint(CGPoint(x: centerX-(iconWidth/2), y: centerY-(iconHeight/2)))
            }
            
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
            if index != statesCount.predecessor() {
                let linePath = UIBezierPath()
                linePath.moveToPoint(CGPoint(x: centerX, y: centerY+self.radius))
                linePath.addLineToPoint(CGPoint(x: centerX, y: centerY+self.radius+self.seperatorLength))
                linePath.lineWidth = self.seperatorWidth
                
                if isNextStateActive {
                    self.circleActiveColor.setStroke()
                }
                else {
                    self.seperatorColor.setStroke()
                }
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
        
    }
    
    // MARK: - Public API
    
    public func reloadData() {
        self.clearIndicatorViews()
        self.setNeedsDisplay()
    }
    
    // MARK: - Indicator Views
    
    private func updateIndicatorViews() {
        if self.rippleView == nil {
            let rippleView = RippleView()
            rippleView.rippleColor = self.circleActiveColor
            self.addSubview(rippleView)
            self.rippleView = rippleView
        }
        
        if let frameForRippleView = self.frameForRippleView, rippleView = self.rippleView {
            rippleView.frame = frameForRippleView
            rippleView.hidden = false
            rippleView.startRippleEffect()
        }
    }
    
    private func clearIndicatorViews() {
        self.rippleView?.hidden = true
        self.rippleView?.stopRippleEffect()
    }
    
    // MARK: - Calculations
    
    private func calculateCircleDiameter() {
        let count = CGFloat(self.statesCount())
        if count > 0 {
            let height = CGRectGetHeight(self.bounds)
            let numOfseperators = count - 1
            
            let heightWithoutSeperatorsAndMargins = height - (numOfseperators * self.seperatorLength) - 2*self.margin
            let diameter = (heightWithoutSeperatorsAndMargins / count)
            
            self.diameter = min(diameter, self.circleMaxSize ?? CGFloat.max)
        }
    }
    
    private func statesCount() -> Int {
        if self.numberOfStates == 0 {
            self.numberOfStates = self.dataSource?.numberOfStatesInCricularStatesView(self) ?? 0
        }
        
        return self.numberOfStates
    }
}

extension UIBezierPath {
    class func circlePathWithCenter(center: CGPoint, diameter: CGFloat, borderWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: diameter/2, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise: true)
        path.lineWidth = borderWidth
        return path
    }
}
