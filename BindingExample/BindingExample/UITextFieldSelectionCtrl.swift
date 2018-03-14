/*******************************************************************************
 * UITextFieldSelectionCtrl.swift                                              *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

class UITextFieldSelectionCtrl: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ctrl = segue.destination as! UITextFieldCtrl
        ctrl.segueBindTextProperty = segue.identifier == "Text";
    }

}
