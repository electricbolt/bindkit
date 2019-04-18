/*******************************************************************************
 * UIImageViewCtrl.swift                                                       *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    var segueBindTextProperty: Bool = false
    @objc dynamic var text: String!
    @objc dynamic var attributedText: NSAttributedString!
    @objc dynamic var hidden: Bool = false

    override init() {
        super.init()
        text = "1234567890"
        attributedText = colorize("1234567890")
    }

    func calculated() -> NSAttributedString {
        let a = AttrStr().appendKey("hidden").appendValue(hidden);
        if segueBindTextProperty {
            return a.appendKey("text").appendValue(text).attributedString()
        } else {
            return a.appendKey("attributedText").appendValue(attributedText).attributedString()
        }
    }

}

class UILabelCtrl: UIViewController {

    @objc fileprivate var model = Model()

    // Set by UILabelSelectionCtrl depending on if the user taps the 'text' or
    // 'attributedText' rows. BindKit supports binding either text or
    // attributedText, but not both at the same time.
    var segueBindTextProperty: Bool {
        set {
            model.segueBindTextProperty = newValue
        } get {
            return model.segueBindTextProperty
        }
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        if segueBindTextProperty {
            // Bind the model.text property to the UILabel.text property
            model.bindKey(#keyPath(model.text), view: label, viewKey: UILabelText)
            self.title = "Text";
        } else {
            // Bind the model.attributedText property to the UILabel.attributedText property
            model.bindKey(#keyPath(model.attributedText), view: label, viewKey: UILabelAttributedText)
            self.title = "AttributedText";
        }
        // Bind the model.hidden property to the UILabel.hidden property
        model.bindKey(#keyPath(model.hidden), view: label, viewKey: UILabelHidden)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func setTextToABC(_ sender: Any) {
        if segueBindTextProperty {
            // Any changes to the model.text property will automatically update the bound UILabel.text property
            model.text = "abcdefghijklmnopqrstuvwxyz"
        } else {
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

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UILabel.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}

