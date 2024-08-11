// RegistrationCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit
import BindKit

class RegistrationCtrl: UITableViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var automobiles: UISwitch!
    @IBOutlet weak var electronics: UISwitch!
    @IBOutlet weak var furniture: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    @objc var model = RegistrationModel()

    override func viewDidLoad() {
        model.bindKey(#keyPath(model.firstName), view: firstName, viewKey: UITextFieldText)
        model.bindKey(#keyPath(model.lastName), view: lastName, viewKey: UITextFieldText)
        model.bindKey(#keyPath(model.email), view: email, viewKey: UITextFieldText)
        model.bindKey(#keyPath(model.inputAge), view: ageStepper, viewKey: UIStepperValue)
        model.bindKey(#keyPath(model.actualAge), view: ageLabel, viewKey: UILabelText)
        model.bindKey(#keyPath(model.subscribeAutomobile), view: automobiles, viewKey: UISwitchOn)
        model.bindKey(#keyPath(model.subscribeElectronics), view: electronics, viewKey: UISwitchOn)
        model.bindKey(#keyPath(model.subscribeFurniture), view: furniture, viewKey: UISwitchOn)
        model.bindKey(#keyPath(model.done), view: doneButton, viewKey: UIBarButtonItemEnabled)

        self.boundPropertiesDelegate = self
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Binding Example", message: "Done pressed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension RegistrationCtrl: EBKBoundPropertiesDelegate {

    override func boundPropertiesDidUpdate() {
    }

}
