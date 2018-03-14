/*******************************************************************************
 * UISliderCtrl.swift                                                          *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    dynamic var enabled: Bool = true
    dynamic var hidden: Bool = false
    dynamic var value: Float = 0

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

class UISliderCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        // Bind the model.enabled property to the UISlider.enabled property
        model.bindKey(#keyPath(model.enabled), view: slider, viewKey: UISliderEnabled)
        // Bind the model.hidden property to the UISlider.hidden property
        model.bindKey(#keyPath(model.hidden), view: slider, viewKey: UISliderHidden)
        // Bind the model.value property to the UISlider.value property
        model.bindKey(#keyPath(model.value), view: slider, viewKey: UISliderValue)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func _0_2_Pressed(_ sender: Any) {
        // Any changes to the model.value property will automatically update the bound UISlider.value property
        model.value = 0.2
    }

    @IBAction func _0_8_Pressed(_ sender: Any) {
        // Any changes to the model.value property will automatically update the bound UISlider.value property
        model.value = 0.8
    }

    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UISlider.enabled property
        model.enabled = enableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UISlider.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}


