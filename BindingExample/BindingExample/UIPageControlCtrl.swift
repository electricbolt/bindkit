/*******************************************************************************
 * UIPageControlCtrl.swift                                                     *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

fileprivate class Model: NSObject {

    dynamic var enabled: Bool = true
    dynamic var hidden: Bool = false
    dynamic var currentPage: Int = 0
    dynamic var numberOfPages: Int = 1

    func calculated() -> NSAttributedString {
        return AttrStr()
            .appendKey("enabled")
            .appendValue(enabled)
            .appendKey("hidden")
            .appendValue(hidden)
            .appendKey("currentPage")
            .appendValue(currentPage)
            .appendKey("numberOfPages")
            .appendValue(numberOfPages)
            .attributedString()
    }

}

class UIPageControlCtrl: UIViewController {

    @objc fileprivate var model = Model()

    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var currentPageStepper: UIStepper!
    @IBOutlet weak var numberOfPagesStepper: UIStepper!
    @IBOutlet weak var calculatedLabel: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad();

        // Bind the model.enabled property to the UIPageControl.enabled property
        model.bindKey(#keyPath(model.enabled), view: pageControl, viewKey: UIPageControlEnabled)
        // Bind the model.hidden property to the UIPageControl.hidden property
        model.bindKey(#keyPath(model.hidden), view: pageControl, viewKey: UIPageControlHidden)
        // Bind the model.currentPage property to the UIPageControl.currentPage property
        model.bindKey(#keyPath(model.currentPage), view: pageControl, viewKey: UIPageControlCurrentPage)
        // Bind the model.numberOfPages property to the UIPageControl.numberOfPages property
        model.bindKey(#keyPath(model.numberOfPages), view: pageControl, viewKey: UIPageControlNumberOfPages)

        model.boundPropertiesUpdateBlock = { [unowned self] in
            self.calculatedLabel.attributedText = self.model.calculated()
        }
    }

    @IBAction func currentPageValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UIPageControl.currentPage property
        model.currentPage = Int(currentPageStepper.value)
    }

    @IBAction func numberOfPagesValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UIPageControl.numberOfPages property
        model.numberOfPages = Int(numberOfPagesStepper.value)
    }

    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.enabled property will automatically update the bound UIPageControl.enabled property
        model.enabled = enableSwitch.isOn
    }

    @IBAction func hiddenSwitchValueChanged(_ sender: Any) {
        // Any changes to the model.hidden property will automatically update the bound UIPageControl.hidden property
        model.hidden = hiddenSwitch.isOn
    }

}
