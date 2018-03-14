/*******************************************************************************
 * UIImageViewCtrl.swift                                                       *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    dynamic var image: UIImage! = UIImage(named: "cat.png")
    dynamic var hidden: Bool = false

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("hidden")
            .appendValue(hidden)
            .appendKey("image")
            .appendValue(image)
            .attributedString()
    }

}

class UIImageViewCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var calculatedLabel: UITextView!
    @IBOutlet weak var imageSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad();

        // Bind the model.image property to the UIImageView.image property
        model.bindKey(#keyPath(model.image), view: imageView, viewKey: UIImageViewImage)
        // Bind the model.hidden property to the UIImageView.hidden property
        model.bindKey(#keyPath(model.hidden), view: imageView, viewKey: UIImageViewHidden)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func segmentChanged(_ sender: Any) {
        // Any changes to the model.image property will automatically update the bound UIImageView.image property
        if (imageSegment.selectedSegmentIndex == 0) {
            model.image = UIImage(named: "cat.png")
        } else {
            model.image = UIImage(named: "dog.png")
        }
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UIImageView.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}
