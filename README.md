# Baby Monitor iOS

Welcome to the **Baby Monitor** project. It's an application made for monitoring babies, which can help parents take care of their children. Application works similar to this product: https://www.philips.ie/c-p/SCD620_05/avent-baby-monitor-digital-video-baby-monitor

## Team

* [Ania Pinderak](mailto:anna.pinderak@netguru.com) - Project Manager
* [Rafał Żurawski](mailto:rafal.zurawski@netguru.com) - QA

## Tools & Services

* Tools:
	* Xcode 11.0 with latest iOS SDK (13.0)
	* [Carthage](https://github.com/Carthage/Carthage) 0.26 or higher
	<!-- * [CocoaPods](https://github.com/CocoaPods/CocoaPods) 1.7.5 or higher -->
* Services:
	* [JIRA](https://netguru.atlassian.net/secure/RapidBoard.jspa?rapidView=620&view=detail)
	* [Bitrise](https://app.bitrise.io/app/80545282645ad180)
	* [HockeyApp - staging](https://rink.hockeyapp.net/manage/apps/838901)

## Configuration

### Prerequisites

- [Bundler](http://bundler.io) (`gem install bundler`)
- [Homebrew](https://brew.sh)
- [Carthage](https://github.com/Carthage/Carthage) (`brew install carthage`)
<!-- - [CocoaPods](https://cocoapods.org) (`brew install cocoapods`) -->

### Instalation

1. Clone repository:

	```bash
	# over https:
	git clone https://github.com/netguru/baby-monitor-client-ios.git
	# or over SSH:
	git clone git@github.com:netguru/baby-monitor-client-ios.git
	```

2. Install required Gems:

	```bash
	bundle install
	```

3. Run Carthage:

	```bash
	carthage bootstrap --platform iOS --cache-builds
	```

4. **Only if cocoapods-keys are applied:** Download `.env` file from project's 1password vault and paste it into the root project's directory.

5. Install pods through Bundler:

	```bash
	bundle exec pod install
	```

6. Open `Baby Monitor.xcworkspace` file and build the project.


## Coding guidelines

- Respect Swift [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- The code must be readable and self-explanatory - full variable names, meaningful methods, etc.
- Don't leave any commented-out code.
- Write documentation for every method and property accessible outside the class. For example well documented method looks as follows:

	for **Swift**:

	```swift
	/// Tells the magician to perform a given trick.
	///
	/// - Parameter trick: The magic trick to perform.
	/// - Returns: Whether the magician succeeded in performing the magic trick.
	func perform(magicTrick trick: MagicTrick) -> Bool {
		// body
	}
	```

## Related repositories

- [baby-monitor-models](https://github.com/netguru/baby-monitor-models)
- [baby-monitor-client-ios](https://github.com/netguru/baby-monitor-client-ios)
- [baby-monitor-client-android](https://github.com/netguru/baby-monitor-client-android)
- [baby-monitor-server-android](https://github.com/netguru/baby-monitor-server-android)

## Tips
### Layout
* Use helper methods from `UIView+AutoLayout.swift`
* Examples:
```swift
addSubview(view)
view.addConstraints {[
    $0.equalConstant(.height, 36), // sets height to 36
    $0.equalConstant(.width, 285), // sets width to 285
    $0.equal(.centerX), // attaches centerXAnchor to superView centerXAnchor
    $0.equalTo(topView, .top, .bottom, constant: 80) // attaches views topAnchor to topView bottom anchor with offset 80
]}
```
