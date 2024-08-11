// AttrStr.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit

class AttrStr {

    var buf: NSMutableAttributedString = NSMutableAttributedString()

    func appendKey(_ key: String) -> AttrStr {
        if buf.length > 0 {
            buf.append(NSAttributedString(string: " "))
        }
        buf.append(NSAttributedString(string: "\(key)=", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0)]))
        return self
    }

    func appendValue(_ value: String?) -> AttrStr {
        buf.append(NSAttributedString(string: value == nil ? "nil" : value!))
        return self
    }

    func appendValue(_ value: NSAttributedString?) -> AttrStr {
        buf.append(value == nil ? NSAttributedString(string: "nil") : value!)
        return self
    }

    func appendValue(_ value: Float) -> AttrStr {
        buf.append(NSAttributedString(string: "\(value)"))
        return self
    }

    func appendValue(_ value: NSDate?) -> AttrStr {
        buf.append(value == nil ? NSAttributedString(string: "nil") : NSAttributedString(string: "\(value!)"))
        return self
    }

    func appendValue(_ value: UIImage?) -> AttrStr {
        if (value == nil) {
            buf.append(NSAttributedString(string: "nil"))
        } else {
            let textAttachment = NSTextAttachment()
            textAttachment.image = value
            let attr = NSAttributedString(attachment: textAttachment)
            buf.append(attr)
        }
        return self
    }

    func appendValue(_ value: Double) -> AttrStr {
        buf.append(NSAttributedString(string: "\(value)"))
        return self
    }

    func appendValue(_ value: Int) -> AttrStr {
        buf.append(NSAttributedString(string: "\(value)"))
        return self
    }

    func appendValue(_ value: Bool) -> AttrStr {
        buf.append(NSAttributedString(string: value == true ? "true" : "false"))
        return self
    }

    func attributedString() -> NSAttributedString {
        return buf;
    }

}
