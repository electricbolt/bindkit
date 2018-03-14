/*******************************************************************************
 * UISwitchCtrl.swift                                                         *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    dynamic var enabled: Bool = true
    dynamic var hidden: Bool = false
    dynamic var onOff: Bool = false

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("enabled")
            .appendValue(enabled)
            .appendKey("hidden")
            .appendValue(hidden)
            .appendKey("on")
            .appendValue(onOff)
            .attributedString()
    }

}

class UISwitchCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        // Bind the model.enabled property to the UISwitch.enabled property
        model.bindKey(#keyPath(model.enabled), view: `switch`, viewKey: UISwitchEnabled)
        // Bind the model.hidden property to the UISwitch.hidden property
        model.bindKey(#keyPath(model.hidden), view: `switch`, viewKey: UISwitchHidden)
        // Bind the model.onOnff property to the UISwitch.on property
        model.bindKey(#keyPath(model.onOff), view: `switch`, viewKey: UISwitchOn)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func truePressed(_ sender: Any) {
        // Any changes to the model.value property will automatically update the bound UISwitch.on property
        model.onOff = true
    }

    @IBAction func falsePressed(_ sender: Any) {
        // Any changes to the model.value property will automatically update the bound UISwitch.on property
        model.onOff = false
    }

    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UISwitch.on property
        model.enabled = enableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UISwitch.on property
        model.hidden = hiddenSwitch.isOn
    }

}




