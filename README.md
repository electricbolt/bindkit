# BindKit

A simple to use two-way data binding framework for iOS.  **Only one API to learn**.

Supports Objective-C, Swift 3 and 4, Xcode 8 and 9, iOS 8 and above.

Supports Xcode 10.0 beta 4 (10L213o) and iOS 12.0 beta 4.

Ships as a cocoapod or static library ready for you to link into your app (or you can include the source directly into your project). The static library is built as a 'fat' library and includes the following architectures: i386, x86_64, armv7s, armv7, arm64 and bitcode.

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
2. Your models properties that participate in binding need to be marked `dynamic`.

See [under the hood](#under-the-hood) for implementation details.

### Example

> Swift

```swift
class LogonModel: NSObject {
	
	dynamic var username: String!
	dynamic var password: String!
	dynamic var logonEnabled: Boolean
	
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

- Link `libBindKit.a` into your app
- Configure `Header Search Paths` to allow Xcode to find `BindKit.h` and `BindKitVendor.h`
- Add `-ObjC` and `-all_load` to `Other Linker Flags`

### Adding BindKit to your app (Cocoapods integration)

- If you have not already created a Podfile for your application, create one now: `pod init`
- Add the following into your Podfile: `pod 'BindKit'`
- Save the file and run: `pod install`

### Building

Whilst the libBindKit.a static library is prebuilt and included in the repository, if you need to rebuild then execute the following command:

`./buildlibrary.sh`

The resulting static library and header files will be placed into the `release` directory.

The build script currently assumes Xcode 9/SDK11.2. If you are using a different Xcode build chain, tweak the `IOSSDK_VER` variable in the build script as appropriate.

### Under the hood

#### Model

Model properties that participate in binding are monitored for changes using Key-Value-Observing (KVO). For this reason model objects must inherit from `NSObject`, and if using Swift, properties must be marked with `dynamic`.

#### View

Views that participate in binding are dynamically subclassed at runtime. There is one dynamic subclass implemented for each supported view. Depending on the view, different methods for monitoring changes are required: target-action, delegation or notifications.

*View not supported?* Submit a pull request with your changes to add the property or class, or use the Vendor API to add custom functionality in your own app.
