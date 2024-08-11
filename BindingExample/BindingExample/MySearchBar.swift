// MySearchBar.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit
import BindKit

let MySearchBarText = "text"

/**
 Demonstrates creating a `custom` dynamic subclass of a view in Swift. You can augment any view with binding
 capabilities that isn't already supported by BindKit.
 */

class MySearchBar: UISearchBar {

    // Changed to malloc(1)! to fix Swift 5.9 warning using strings for associated object contexts:
    // https://forums.swift.org/t/handling-the-new-forming-unsaferawpointer-warning/65523/7
    fileprivate static var multicastContext = malloc(1)!
    fileprivate static var searchBarDelegateContext = malloc(1)!

    override func viewDidBindWithModel() {
        // UIView subclasses can't have a delegate pointing to itself, instead
        // we need to create another object to be the delegate.
        let searchBarDelegate = MySearchBarDelegate(self)

        // With dynamic subclasses you can't use instance variables, instead
        // we must use associated objects to store any state.
        objc_setAssociatedObject(self, &MySearchBar.searchBarDelegateContext, searchBarDelegate, .OBJC_ASSOCIATION_RETAIN)

        // Remember if the delegate was set before we were dynamically subclassed.
        let previousDelegate = super.delegate

        // EBKMulticastDelegate can be used when the only way to be notified
        // of changes to a view is through a delegate.
        let multicast = EBKMulticastDelegate()
        objc_setAssociatedObject(self, &MySearchBar.multicastContext, multicast as EBKMulticastDelegate?, .OBJC_ASSOCIATION_RETAIN)
        super.delegate = unsafeBitCast(multicast, to: UISearchBarDelegate.self)
        multicast.primaryDelegate = searchBarDelegate

        // Restore the any previous delegate that may have been set.
        if previousDelegate != nil {
            multicast.secondaryDelegate = previousDelegate
        }
    }

    override var delegate: UISearchBarDelegate? {
        set {
            // 'set' updates the EBKMulticastDelegate.secondaryDelegate property.
            let multicast = objc_getAssociatedObject(self, &MySearchBar.multicastContext) as! EBKMulticastDelegate?
            multicast!.secondaryDelegate = newValue
        }
        get {
            // 'get' always return the EBKMulticastDelegate instance.
            return (objc_getAssociatedObject(self, &MySearchBar.multicastContext) as! UISearchBarDelegate)
        }
    }

    override func bindableProperties() -> [String:String] {
        return [MySearchBarText: "NSString"]
    }

    override var text: String? {
        set {
            // BindKit suggests that you don't set properties if the value hasn't changed.
            if self.text != newValue {
                super.text = newValue
            }
            let v = boundValue(viewKey: MySearchBarText)
            if v is NSNull {
                if newValue != nil {
                    setBoundValue(nil, viewKey: MySearchBarText)
                }
            } else if v is String {
                if newValue != (v as! String) {
                    setBoundValue(newValue as NSObject?, viewKey: MySearchBarText)
                }
            }
        }
        get {
            return self.text
        }
    }

    override func updateViewFromBoundModel() {
        // BindKit suggests that you don't set properties if the value hasn't changed.
        let v = boundValue(viewKey: MySearchBarText)
        if v is NSNull {
            if super.text != nil {
                super.text = nil
            }
        } else if v is String {
            if super.text != (v as! String) {
                super.text = (v as! String)
            }
        }
    }
}

class MySearchBarDelegate: NSObject, UISearchBarDelegate {

    var searchBar: MySearchBar

    init(_ searchBar: MySearchBar) {
        self.searchBar = searchBar
        super.init()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let v = searchBar.boundValue(viewKey: MySearchBarText)
        if v is String {
            if (v as! String) != searchText {
                searchBar.setBoundValue(searchText as NSObject?, viewKey: MySearchBarText)
            }
        }
    }

}

extension UISearchBar {

    override open func EBKDynamicSubclass() -> AnyClass? {
        return MySearchBar.self
    }

}
