// UILabelSelectionCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit

class UILabelSelectionCtrl: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ctrl = segue.destination as! UILabelCtrl
        ctrl.segueBindTextProperty = segue.identifier == "Text";
    }

}
