// UITextFieldSelectionCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit

class UITextFieldSelectionCtrl: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ctrl = segue.destination as! UITextFieldCtrl
        ctrl.segueBindTextProperty = segue.identifier == "Text";
    }

}
