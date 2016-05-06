# CircularStatesView

![CircularStatesView: Simple states view in Swift](https://raw.githubusercontent.com/orxelm/CircularStatesView/master/assets/circularstatesview-logo.jpg)

CircularStatesView is a custom view written in Swift, which allows you to dispaly a vertical states progress. We used it our Brisk app to show the customer an order process. See the example project.
## Demo

!attach gif here!

## Requirements
Swift 2+

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
	}
```

Then use the dataSource protocol
```swift
extension ViewController: CircularStatesViewDataSource {
    
    func numberOfStatesInCricularStatesView(cricularStatesView: CircularStatesView) -> Int {
        return 4
    }
    
    func cricularStatesView(cricularStatesView: CircularStatesView, isStateActiveAtIndex index: Int) -> Bool {
        return index <= self.myModelState
    }
}
```

## Properties

## Methods

## Protocol

## TO-DO
- [x] Add title labels
- [x] Add state image icon
- [x] Center align all container
- [x] Add custom view to circle (e.g activity indicator view)
- [x] Add ripple effect to states
- [x] Support Interface Orientations
- [ ] Support @IBDesignable
- [ ] Finish documentation
- [ ] Remove debug prints
- [ ] Support Cocoapods
