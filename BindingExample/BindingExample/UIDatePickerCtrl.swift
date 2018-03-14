/*******************************************************************************
 * UIDatePickerCtrl.swift                                                      *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    dynamic var date: NSDate? = NSDate()
    dynamic var enabled: Bool = true
    dynamic var hidden: Bool = false

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("date")
            .appendValue(date)
            .appendKey("enabled")
            .appendValue(enabled)
            .appendKey("hidden")
            .appendValue(hidden)
            .attributedString()
    }

}

class UIDatePickerCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        // Bind the model.date property to the UIDatePicker.date property
        model.bindKey(#keyPath(model.date), view: datePicker, viewKey: UIDatePickerDate)
        // Bind the model.enabled property to the UIDatePicker.enabled property
        model.bindKey(#keyPath(model.enabled), view: datePicker, viewKey: UIDatePickerEnabled)
        // Bind the model.hidden property to the UIDatePicker.hidden property
        model.bindKey(#keyPath(model.hidden), view: datePicker, viewKey: UIDatePickerHidden)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func setDateToNow(_ sender: Any) {
        // Any changes to the model.date property will automatically update the bound UIDatePicker.date property
        model.date = NSDate()
    }

    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UIDatePicker.enabled property
        model.enabled = enableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UIDatePicker.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}

