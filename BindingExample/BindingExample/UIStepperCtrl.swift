// UIStepperCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit
import BindKit

fileprivate class Model: NSObject {

    @objc dynamic var enabled: Bool = true
    @objc dynamic var hidden: Bool = false
    @objc dynamic var value: Double = 0.0

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("enabled")
            .appendValue(enabled)
            .appendKey("hidden")
            .appendValue(hidden)
            .appendKey("value")
            .appendValue(value)
            .attributedString()
    }

}

class UIStepperCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        // Bind the model.enabled property to the UIStepper.enabled property
        model.bindKey(#keyPath(model.enabled), view: stepper, viewKey: UIStepperEnabled)
        // Bind the model.hidden property to the UIStepper.hidden property
        model.bindKey(#keyPath(model.hidden), view: stepper, viewKey: UIStepperHidden)
        // Bind the model.value property to the UIStepper.value property
        model.bindKey(#keyPath(model.value), view: stepper, viewKey: UIStepperValue)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func _2_Pressed(_ sender: Any) {
        // Any changes to the model.value property will automatically update the bound UIStepper.value property
        model.value = 2.0
    }

    @IBAction func _8_Pressed(_ sender: Any) {
        // Any changes to the model.value property will automatically update the bound UIStepper.value property
        model.value = 8.0
    }

    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UIStepper.enabled property
        model.enabled = enableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UIStepper.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}



