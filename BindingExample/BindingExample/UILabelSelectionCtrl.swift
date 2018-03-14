/*******************************************************************************
 * UILabelSelectionCtrl.swift                                                  *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

class UILabelSelectionCtrl: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ctrl = segue.destination as! UILabelCtrl
        ctrl.segueBindTextProperty = segue.identifier == "Text";
    }

}
