# CircularStatesView

![CircularStatesView: Simple states view in Swift](https://raw.githubusercontent.com/orxelm/CircularStatesView/master/assets/circularstatesview-logo.jpg)

CircularStatesView is a custom view written in Swift, which allows you to dispaly a vertical states progress. We used it our Brisk app to show the customer an order process. See the example project.
## Demo
![Demo](https://raw.githubusercontent.com/orxelm/CircularStatesView/master/assets/circularstatesview-demo.gif)

## Requirements
Swift 2.2+

## Installation
### CocoaPods (Soon)

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate CircularStatesView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'CircularStatesView'
```

Then, run the following command:

```bash
$ pod install
```

## Usage
Add it as a subview in your Storyboard/Code.
```swift
override func viewDidLoad() {
	super.viewDidLoad()

    self.statesView.dataSource = self
    self.statesView.circleMaxSize = 80
    self.statesView.backgroundColor = UIColor.whiteColor()
    ...
}
```

Then use the CircularStatesViewDataSource protocol
```swift
extension ViewController: CircularStatesViewDataSource {
    
    func numberOfStatesInCricularStatesView(cricularStatesView: CircularStatesView) -> Int {
        return 4
    }
    
    func cricularStatesView(cricularStatesView: CircularStatesView, isStateActiveAtIndex index: Int) -> Bool {
        return index <= self.myModelState
    }
    ...
}
```

## Properties
```swift
// The DataSource
public weak var dataSource: CircularStatesViewDataSource?
    
/// The number of states in view
public var numberOfStates: Int {get}

/// The circle's active state fill color
public var circleActiveColor: UIColor

/// The circle's in-active state fill color
public var circleInactiveColor: UIColor

/// The circle's border color
public var circleBorderColor: UIColor

/// The width of the border
public var circleBorderWidth: CGFloat

/// The maximum value for the circle diameter
public var circleMaxSize: CGFloat?

/// The length of the seperator line between each circle state
public var seperatorLength: CGFloat

/// The line seperator color
public var seperatorColor: UIColor

/// The line seperator width
public var seperatorWidth: CGFloat

/// The states title font
public var stateTitleFont: UIFont

/// The color for the active title text label
public var titleLabelActiveTextColor: UIColor

/// The color for the inactive title text label
public var titleLabelInactiveTextColor: UIColor

/// The index for the state with activity indicator
public var indexForStateWithActivityIndicator: Int?

/// The color for the activity indicator
public var stateActivityIndicatorColor: UIColor
```
## Methods
DataSource reloadData
```swift
func reloadData()
```

## Protocol
The DataSource protocol
```swift
public protocol CircularStatesViewDataSource: class {
    /**
     Return the number of states in the view
     - parameter circularStatesView: The CircularStatesView
     - returns: The number of states
     */
    func numberOfStatesInCircularStatesView(circularStatesView: CircularStatesView) -> Int
    
    /**
     Return whether the state at index is active or inactive
     - parameter circularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: true/false for active/inactive state
     */
    func circularStatesView(circularStatesView: CircularStatesView, isStateActiveAtIndex index: Int) -> Bool
    
    /**
     Return the title string for the state, this title we'll be displayed along side the state
     - parameter circularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: title string or nil if you don't need a title for the specific state
     */
    func circularStatesView(circularStatesView: CircularStatesView, titleForStateAtIndex index: Int) -> String?
    
    /**
     Return image icon for active state, this icon will be shown in the circle center
     - parameter circularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: UIImage for the image icon or nil if you don't want to show an icon
     */
    func circularStatesView(circularStatesView: CircularStatesView, imageIconForActiveStateAtIndex index: Int) -> UIImage?
    
    /**
     Return image icon for inactive state, this icon will be shown in the circle center
     - parameter circularStatesView: The CircularStatesView
     - parameter index: The state index
     - returns: UIImage for the image icon or nil if you don't want to show an icon
     */
    func circularStatesView(circularStatesView: CircularStatesView, imageIconForInActiveStateAtIndex index: Int) -> UIImage?
}
```

##Author
CircularStatesView is owned and maintained by Or Elmaliah. You can follow me on Twitter [@OrElm](https://twitter.com/orelm).

## TO-DO
- [ ] Add optional title label to state circle center (set priority to image or title?)
- [x] Add title labels
- [x] Add state image icon
- [x] Center align all container
- [x] Add custom view to circle (e.g activity indicator view)
- [x] Add ripple effect to states
- [x] Support Interface Orientations
- [x] Support @IBDesignable,@IBInspectable
- [ ] Finish documentation
- [ ] Remove debug prints
- [ ] Support Cocoapods
