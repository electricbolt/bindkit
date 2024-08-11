// UIButtonCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit
import BindKit

fileprivate class Model: NSObject {
    
    @objc dynamic var enabled: Bool = true
    @objc dynamic var hidden: Bool = false
    
    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("enabled")
            .appendValue(enabled)
            .appendKey("hidden")
            .appendValue(hidden)
            .attributedString()
    }
    
}

class UIButtonCtrl: UIViewController {
    
    @objc fileprivate var model = Model()
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Bind the model.enabled property to the UIButton.enabled property
        model.bindKey(#keyPath(model.enabled), view: button, viewKey: UIButtonEnabled)
        // Bind the model.hidden property to the UIButton.hidden property
        model.bindKey(#keyPath(model.hidden), view: button, viewKey: UIButtonHidden)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }
    
    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UIButton.enabled property
        model.enabled = enableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UIButton.hidden property
        model.hidden = hiddenSwitch.isOn
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Binding Example", message: "UIButton pressed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
