/*******************************************************************************
 * UISegmentedControlCtrl.swift                                                *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    dynamic var enabled: Bool = true
    dynamic var hidden: Bool = false
    dynamic var selectedSegmentIndex: Int = 0

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("enabled")
            .appendValue(enabled)
            .appendKey("hidden")
            .appendValue(hidden)
            .appendKey("selectedSegmentIndex")
            .appendValue(selectedSegmentIndex)
            .attributedString()
    }

}

class UISegmentedControlCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var selectedSegmentIndex: UISegmentedControl!
    @IBOutlet weak var segmentedControl: UISegmentedControl! // The view we're binding to
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        // Bind the model.enabled property to the UISegmentedControl.enabled property
        model.bindKey(#keyPath(model.enabled), view: segmentedControl, viewKey: UISegmentedControlEnabled)
        // Bind the model.hidden property to the UISegmentedControl.hidden property
        model.bindKey(#keyPath(model.hidden), view: segmentedControl, viewKey: UISegmentedControlHidden)
        // Bind the model.currentPage property to the UISegmentedControl.selectedSegmentIndex property
        model.bindKey(#keyPath(model.selectedSegmentIndex), view: segmentedControl, viewKey: UISegmentedControlSelectedSegmentIndex)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func selectedSegmentedIndexValueChanged(_ sender: Any) {
        // Any changes to the model.selectedSegmentIndex property will automatically update the bound UISegmentedControl.selectedSegmentIndex property
        model.selectedSegmentIndex = Int(selectedSegmentIndex.selectedSegmentIndex)
    }

    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UISegmentedControl.enabled property
        model.enabled = enableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UISegmentedControl.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}

