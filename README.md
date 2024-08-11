# BindKit

A simple to use two-way UIKit data binding framework for iOS. **Only one API to learn**.

Supports Objective-C, Swift 5.10, Xcode 15.4, iOS 13+. Distributed as a static XCFramework ready for you to link into your app.

### Currently supported views

The following views are supported directly by BindKit:

View class | View properties
-----------|--------------
UIBarButtonItem | enabled
UIButton | enabled, hidden
UIDatePicker | date, enabled, hidden
UIImageView | image, hidden
UILabel | text, attributedText, hidden
UIPageControl | currentPage, numberOfPages, enabled, hidden
UISegmentedControl | selectedSegmentIndex, enabled, hidden
UISlider | value, enabled, hidden
UIStepper | value, enabled, hidden
UISwitch | on, enabled, hidden
UITextFieldText | text, attributedText, enabled, hidden
UITextView | text, attributedText, editable, hidden

*Don't see the property or class you're interested in?* Submit a pull request with your changes to add the property or class, or use the Vendor API to add custom functionality in your own app. See `MySearchBar.swift` in `BindingExample` for an example of custom functionality using the Vendor API.

### Binding

Data binding is **two-way** - any changes to your models properties are automatically applied to your views properties and vice versa.

There is only one API to learn:

> Objective-C

```objc
[model bindObjectSel: @selector(addressStr) toView: addressTextField viewKey: UITextFieldText];
```

> Swift

```swift
model.bindObjectKey(#keyPath(model.addressStr), toView: addressTextField, viewKey: UITextFieldText)
```

### Just a few simple rules

The following rules apply when using BindKit with Swift:

1. Your model object must inherit from `NSObject`.
2. Your models properties that participate in binding need to be marked `@objc dynamic`.

See [under the hood](#under-the-hood) for implementation details.

### Example

> Swift

```swift
class LogonModel: NSObject {
	
	@objc dynamic var username: String!
	@objc dynamic var password: String!
	@objc dynamic var logonEnabled: Boolean
	
	override func boundPropertiesDidUpdate() {
		logonEnabled = validate()
	}

	func validate() -> Boolean
		guard username!.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else { return false }
		guard password!.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else { return false }
		return true
	}
}

class LogonController: UITableViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var logonButton: UIButton!

	var model = LogonModel()

	override func viewDidLoad() {
		model.bindKey(#keyPath(model.username), view: usernameTextField, viewKey: UITextFieldText)
		model.bindKey(#keyPath(model.password), view: passwordTextField, viewKey: UITextFieldText)
		model.bindKey(#keyPath(model.logonEnabled), view: logonButton, viewKey: UIButtonEnabled)
	}

}
```

### Adding BindKit to your app (Manual integration)

- Link `BindKit.xcframework` into your app.
- Add the build settings `-ObjC` and `-all_load` to `Other Linker Flags`.

### Adding BindKit to your app (Swift Package Manager)

- Add a Swift Package Manager dependency with the URL `https://github.com/electricbolt/bindkit`.
- Add the build settings `-ObjC` and `-all_load` to `Other Linker Flags`.

### Building

Whilst the static XCFramework is prebuilt and included in the repository, if you need to rebuild then follow these steps:

- Edit the `buildframework.sh` file. Comment out the `codesign` line.
- Execute the command `./buildframework.sh`.

The resulting static XCFramework will be placed into the root of the project.

The build script currently assumes iOS SDK 17.5. If you are using a different Xcode build chain, tweak the `IOSSDK_VER` variable in the build script as appropriate.

### Under the hood

#### Model

Model properties that participate in binding are monitored for changes using Key-Value-Observing (KVO). For this reason model objects must inherit from `NSObject`, and if using Swift, properties must be marked with `@objc dynamic`.

#### View

Views that participate in binding are dynamically subclassed at runtime. There is one dynamic subclass implemented for each supported view. Depending on the view, different methods for monitoring changes are required: target-action, delegation or notifications.

*View not supported?* Submit a pull request with your changes to add the property or class, or use the Vendor API to add custom functionality in your own app.
