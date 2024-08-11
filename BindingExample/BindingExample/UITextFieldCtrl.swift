// UITextFieldCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit
import BindKit

fileprivate class Model: NSObject {

    var segueBindTextProperty: Bool = false
    @objc dynamic var text: String!
    @objc dynamic var attributedText: NSAttributedString!
    @objc dynamic var enabled: Bool = true
    @objc dynamic var hidden: Bool = false

    override init() {
        super.init()
        text = "1234567890"
        attributedText = colorize("1234567890")
    }

    func calculated() -> NSAttributedString {
        let a = AttrStr()
            .appendKey("enabled")
            .appendValue(enabled)
            .appendKey("hidden")
            .appendValue(hidden);
        if segueBindTextProperty {
            return a.appendKey("text").appendValue(text).attributedString()
        } else {
            return a.appendKey("attributedText").appendValue(attributedText).attributedString()
        }
    }

}

class UITextFieldCtrl: UIViewController {

    @objc fileprivate var model = Model()

    // Set by UITextFieldSelectionCtrl depending on if the user taps the 'text' or
    // 'attributedText' rows. BindKit supports binding either text or
    // attributedText, but not both at the same time.
    var segueBindTextProperty: Bool {
        set {
            model.segueBindTextProperty = newValue
        } get {
            return model.segueBindTextProperty
        }
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        if segueBindTextProperty {
            // Bind the model.text property to the UITextField.text property
            model.bindKey(#keyPath(model.text), view: textField, viewKey: UITextFieldText)
            self.title = "Text";
        } else {
            // Bind the model.attributedText property to the UITextField.attributedText property
            model.bindKey(#keyPath(model.attributedText), view: textField, viewKey: UITextFieldAttributedText)
            self.title = "AttributedText";
        }
        // Bind the model.enabled property to the UITextField.enabled property
        model.bindKey(#keyPath(model.enabled), view: textField, viewKey: UITextFieldEnabled)
        // Bind the model.hidden property to the UITextField.hidden property
        model.bindKey(#keyPath(model.hidden), view: textField, viewKey: UITextFieldHidden)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func setTextToABC(_ sender: Any) {
        if segueBindTextProperty {
            // Any changes to the model.text property will automatically update the bound UITextField.text property
            model.text = "abcdefghijklmnopqrstuvwxyz"
        } else {
            // Any changes to the model.attributedText property will automatically update the bound UITextField.attributedText property
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

    @IBAction func enabledSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UITextField.enabled property
        model.enabled = enabledSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UITextField.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}


