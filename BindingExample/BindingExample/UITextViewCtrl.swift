// UITextViewCtrl.swift
// BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.

import UIKit
import BindKit

fileprivate class Model: NSObject {

    var segueBindTextProperty: Bool = false
    @objc dynamic var text: String!
    @objc dynamic var attributedText: NSAttributedString!
    @objc dynamic var editable: Bool = true
    @objc dynamic var hidden: Bool = false

    override init() {
        super.init()
        text = "1234567890"
        attributedText = colorize("1234567890")
    }

    func calculated() -> NSAttributedString {
        let a = AttrStr()
            .appendKey("editable")
            .appendValue(editable)
            .appendKey("hidden")
            .appendValue(hidden);
        if segueBindTextProperty {
            return a.appendKey("text").appendValue(text).attributedString()
        } else {
            return a.appendKey("attributedText").appendValue(attributedText).attributedString()
        }
    }

}

class UITextViewCtrl: UIViewController {

    @objc fileprivate var model = Model()

    // Set by UITextViewSelectionCtrl depending on if the user taps the 'text' or
    // 'attributedText' rows. BindKit supports binding either text or
    // attributedText, but not both at the same time.
    var segueBindTextProperty: Bool {
        set {
            model.segueBindTextProperty = newValue
        } get {
            return model.segueBindTextProperty
        }
    }

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var editableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        if segueBindTextProperty {
            // Bind the model.text property to the UITextView.text property
            model.bindKey(#keyPath(model.text), view: textView, viewKey: UITextViewText)
            self.title = "Text";
        } else {
            // Bind the model.attributedText property to the UITextView.attributedText property
            model.bindKey(#keyPath(model.attributedText), view: textView, viewKey: UITextViewAttributedText)
            self.title = "AttributedText";
        }
        // Bind the model.editable property to the UITextView.editable property
        model.bindKey(#keyPath(model.editable), view: textView, viewKey: UITextViewEditable)
        // Bind the model.hidden property to the UITextView.hidden property
        model.bindKey(#keyPath(model.hidden), view: textView, viewKey: UITextViewHidden)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func setTextToABC(_ sender: Any) {
        if segueBindTextProperty {
            // Any changes to the model.text property will automatically update the bound UITextView.text property
            model.text = "abcdefghijklmnopqrstuvwxyz"
        } else {
            // Any changes to the model.attributedText property will automatically update the bound UITextView.attributedText property
            model.attributedText = colorize("abcdefghijklmnopqrstuvwxyz")
        }
    }

    @IBAction func setTextTo123(_ sender: Any) {
        if segueBindTextProperty {
            model.text = "1234567890"
        } else {
            model.attributedText = colorize("1234567890")
        }
    }


    @IBAction func setTextToNil(_ sender: Any) {
        if segueBindTextProperty {
            model.text = nil
        } else {
            model.attributedText = nil
        }
    }

    @IBAction func editableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UITextView.editable property
        model.editable = editableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UITextView.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}



