// UITextViewSelectionCtrl.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit

class UITextViewSelectionCtrl: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ctrl = segue.destination as! UITextViewCtrl
        ctrl.segueBindTextProperty = segue.identifier == "Text";
    }

}

