//
//  CircularStatesView.swift
//  CircularStatesView
//
//  Created by Or Elmaliah on 01/05/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

public protocol CircularStatesViewDataSource: class {
    /**
     Return the number of states in the view
     - parameter cricularStatesView: The CircularStatesView
     - returns: The number of states
     */
    func numberOfStatesInCricularStatesView(cricularStatesView: CircularStatesView) -> Int
    
    /**
     Return whether the state at index is active or inactive
     - parameter cricularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: true/false for active/inactive state
     */
    func cricularStatesView(cricularStatesView: CircularStatesView, isStateActiveAtIndex index: Int) -> Bool
    
    /**
     Return the title string for the state, this title we'll be displayed along side the state
     - parameter cricularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: title string or nil if you don't need a title for the specific state
     */
    func cricularStatesView(cricularStatesView: CircularStatesView, titleForStateAtIndex index: Int) -> String?
    
    /**
     Return image icon for active state, this icon will be shown in the circle center
     - parameter cricularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: UIImage for the image icon or nil if you don't want to show an icon
     */
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForActiveStateAtIndex index: Int) -> UIImage?
    
    /**
     Return image icon for inactive state, this icon will be shown in the circle center
     - parameter cricularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: UIImage for the image icon or nil if you don't want to show an icon
     */
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForInActiveStateAtIndex index: Int) -> UIImage?
}

@IBDesignable
public class CircularStatesView: UIView {
    
    // MARK: - Properties (Public)
    
    public weak var dataSource: CircularStatesViewDataSource?
    
    /// The number of states in view
    public private(set) var numberOfStates: Int = 0
    
    /// The circle's active state fill color
    @IBInspectable
    public var circleActiveColor: UIColor = .blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The circle's in-active state fill color
    @IBInspectable
    public var circleInactiveColor: UIColor = .lightGrayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The circle's border color
    @IBInspectable
    public var circleBorderColor: UIColor = .grayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The width of the border
    @IBInspectable
    public var circleBorderWidth: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The maximum value for the circle diameter
    @IBInspectable
    public var circleMaxSize: CGFloat? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The length of the seperator line between each circle state
    @IBInspectable
    public var seperatorLength: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The line seperator color
    @IBInspectable
    public var seperatorColor: UIColor = .grayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The line seperator width
    @IBInspectable
    public var seperatorWidth: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The states title font
    @IBInspectable
    public var stateTitleFont: UIFont = .systemFontOfSize(17) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The color for the active title text label
    @IBInspectable
    public var titleLabelActiveTextColor: UIColor = .blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The color for the inactive title text label
    @IBInspectable
    public var titleLabelInactiveTextColor: UIColor = .lightGrayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The index for the state with activity indicator
    public var indexForStateWithActivityIndicator: Int?
    
    /// The color for the activity indicator
    @IBInspectable
    public var stateActivityIndicatorColor: UIColor = .whiteColor()
    
    // MARK: - Properties (Private)
    
    private var diameter: CGFloat = 0
    private var radius: CGFloat {
        return self.diameter / 2.0
    }
    private let margin: CGFloat = 8
    
    // MARK: - State Indicators (Private)
    
    private var frameForRippleView: CGRect?
    private var frameForIndicatorView: CGRect?
    private var rippleView: RippleView?
    private var indicatorView: CircularIndicatorView?
    
    // MARK: - NSObject
    
    deinit {
        self.rippleView?.stopRippleEffect()
        self.rippleView = nil
        self.indicatorView = nil
    }
    
    // MARK: - UIView
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let statesCount = self.statesCount()
        let centerX = self.leadingMargin() + self.radius + self.margin
        
        for index in 0..<statesCount {
            // State Circle
            let centerY = self.radius + CGFloat(index) * (self.diameter + self.seperatorLength) + self.topMargin()
            let circularPath = UIBezierPath.circlePathWithCenter(CGPoint(x: centerX, y: centerY), diameter: self.diameter, borderWidth: self.circleBorderWidth)
            
            let isActive = self.dataSource?.cricularStatesView(self, isStateActiveAtIndex: index)
            var isNextStateActive = false
            if isActive == true {
                self.circleActiveColor.setFill()
            
                if index < statesCount.predecessor() {
                    isNextStateActive = self.dataSource?.cricularStatesView(self, isStateActiveAtIndex: index.successor()) ?? false
                    if isNextStateActive == false {
                        if index == self.indexForStateWithActivityIndicator {
                            self.frameForIndicatorView = circularPath.bounds
                        }
                        else {
                            self.frameForRippleView = circularPath.bounds
                        }
                        
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
            let text = self.dataSource?.cricularStatesView(self, titleForStateAtIndex: index)
            let titleLabel = self.crateTitleLabelWithText(text, active: isActive ?? false)
            titleLabel.drawTextInRect(CGRect(x: centerX + self.radius + self.margin, y: centerY - (titleLabel.frame.height/2), width: titleLabel.frame.width, height: titleLabel.frame.height))
            
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.calculateCircleDiameter()
        self.setNeedsDisplay()
    }
    
    // MARK: - Public API
    
    public func reloadData() {
        self.clearIndicatorViews()
        self.setNeedsDisplay()
    }
    
    // MARK: - Indicator Views
    
    private func updateIndicatorViews() {
        if let frameForIndicatorView = self.frameForIndicatorView {
            if self.indicatorView == nil {
                let indicatorView = CircularIndicatorView()
                indicatorView.indicatorColor = self.stateActivityIndicatorColor
                self.addSubview(indicatorView)
                self.indicatorView = indicatorView
            }
            
            var frame = frameForIndicatorView
            frame.origin.x += self.margin/2
            frame.origin.y += self.margin/2
            frame.size.width -= self.margin
            frame.size.height -= self.margin
            self.indicatorView?.frame = frame
            self.indicatorView?.hidden = false
        }
        else {
            if let frameForRippleView = self.frameForRippleView {
                if self.rippleView == nil {
                    let rippleView = RippleView()
                    rippleView.rippleColor = self.circleActiveColor
                    self.addSubview(rippleView)
                    self.rippleView = rippleView
                }
                
                self.rippleView?.frame = frameForRippleView
                self.rippleView?.hidden = false
                self.rippleView?.startRippleEffect()
            }
        }
    }
    
    private func clearIndicatorViews() {
        self.rippleView?.hidden = true
        self.rippleView?.stopRippleEffect()
        self.indicatorView?.hidden = true
        self.frameForRippleView = nil
        self.frameForIndicatorView = nil
    }
    
    // MARK: - Factory
    
    private func crateTitleLabelWithText(text: String?, active: Bool = false) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.font = self.stateTitleFont
        titleLabel.textColor = active ? self.titleLabelActiveTextColor : self.titleLabelInactiveTextColor
        titleLabel.numberOfLines = 0
        let width = CGRectGetWidth(self.bounds)
        let titleMaxWidth = width - (self.diameter + 3*self.margin) // |-| (state_diameter) |-| (title) |-|
        let titleMaxHeight = self.diameter - (2 * self.margin)
        let sizeThatFits = titleLabel.sizeThatFits(CGSize(width: titleMaxWidth, height: titleMaxHeight))
        let titleWidth = min(titleMaxWidth, sizeThatFits.width)
        let titleHeight = min(titleMaxHeight, sizeThatFits.height)
        let titleFrame = CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight)
        titleLabel.frame = titleFrame
        
        return titleLabel
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
    
    private func titleLabelMaxWidth() -> CGFloat {
        let statesCount = self.statesCount()
        
        var maxWidth: CGFloat = 0
        for index in 0..<statesCount {
            let text = self.dataSource?.cricularStatesView(self, titleForStateAtIndex: index)
            let titleLabel = self.crateTitleLabelWithText(text)
            
            maxWidth = max(maxWidth, titleLabel.frame.width)
        }
        
        return maxWidth
    }
    
    private func leadingMargin() -> CGFloat {
        let width = CGRectGetWidth(self.bounds)
        let totalMargin = width - (self.diameter + self.titleLabelMaxWidth() + 3*self.margin) // |-| (state_diameter) |-| (title_max_width) |-|
        let leadingMargin = max(totalMargin / 2, self.margin)
        return leadingMargin
    }
    
    private func topMargin() -> CGFloat {
        let statesCount = self.statesCount()
        let height = CGRectGetHeight(self.bounds)
        let totalMargin = height - (CGFloat(statesCount) * self.diameter + CGFloat(statesCount.predecessor()) * self.seperatorLength)
        let marginFromTop = totalMargin / 2
        return marginFromTop
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
