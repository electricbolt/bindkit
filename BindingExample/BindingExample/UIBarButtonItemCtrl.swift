// UIBarButtonItemCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit
import BindKit

fileprivate class Model: NSObject {
    
    @objc dynamic var enabled: Bool = true

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("enabled")
            .appendValue(enabled)
            .attributedString()
    }

}

class UIBarButtonItemCtrl: UIViewController {
    
    @objc fileprivate var model = Model()
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Bind the model.enabled property to the UIBarButtonItem.enabled property
        model.bindKey(#keyPath(model.enabled), view: barButtonItem, viewKey: UIBarButtonItemEnabled)
        
        model.boundPropertiesDelegate = self
    }
    
    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UIBarButtonItem.enabled property
        model.enabled = enableSwitch.isOn
    }
    
    @IBAction func barButtonItemPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Binding Example", message: "UIBarButtonItem pressed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIBarButtonItemCtrl: EBKBoundPropertiesDelegate {
    
    override func boundPropertiesDidUpdate() {
        calculatedLabel.attributedText = model.calculated()
    }
    
}
