/*******************************************************************************
 * MySearchBarCtrl.swift                                                       *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    @objc dynamic var text: String!

    override init() {
        super.init()
        text = "1234567890"
    }

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("text")
            .appendValue(text)
            .attributedString()
    }

}

class MySearchBarCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var calculatedLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();

        searchBar.delegate = self

        // Bind the model.text property to the UISearchBar.text property
        model.bindKey(#keyPath(model.text), view: searchBar, viewKey: MySearchBarText)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func setTextToABC(_ sender: Any) {
        // Any changes to the model.text property will automatically update the bound UILabel.text property
        model.text = "abcdefghijklmnopqrstuvwxyz"
    }

    @IBAction func setTextTo123(_ sender: Any) {
        model.text = "1234567890"
    }


    @IBAction func setTextToNil(_ sender: Any) {
        model.text = nil
    }

}

extension MySearchBarCtrl: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Confirms that the EBKMulticastDelegate used in MySearchBar is
        // working - should call both delegate's searchBar(_:textDidChange:) methods.
        EBKLogS(.error, "\(searchText)")
    }

}

