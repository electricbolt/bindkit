// RegistrationModel.swift
// BindingExample - BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

import UIKit
import BindKit

class RegistrationModel: NSObject {

    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var email: String?
    @objc dynamic var inputAge: Double {
        didSet {
            actualAge = String(format: "%.0f", inputAge);
        }
    }
    @objc dynamic var actualAge: String?
    @objc dynamic var subscribeAutomobile: Bool
    @objc dynamic var subscribeElectronics: Bool
    @objc dynamic var subscribeFurniture: Bool
    @objc dynamic var done: Bool

    override init() {
        firstName = ""
        lastName = ""
        email = ""
        inputAge = 18.0
        actualAge = "18"
        subscribeAutomobile = true
        subscribeElectronics = false
        subscribeFurniture = false
        done = false
    }

    override func boundPropertiesDidUpdate() {
        done = validate()
    }

    func validate() -> Bool {
        guard firstName!.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else { return false }
        guard lastName!.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else { return false }
        guard email!.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else { return false }
        guard inputAge >= 18.0 || inputAge <= 99.0 else { return false }
        guard subscribeFurniture || subscribeAutomobile || subscribeElectronics else { return false }
        return true
    }
}
