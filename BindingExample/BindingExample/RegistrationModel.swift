/*******************************************************************************
 * RegistrationModel.swift                                                     *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

class RegistrationModel: NSObject {

    dynamic var firstName: String?
    dynamic var lastName: String?
    dynamic var email: String?
    dynamic var inputAge: Double {
        didSet {
            actualAge = String(format: "%.0f", inputAge);
        }
    }
    dynamic var actualAge: String?
    dynamic var subscribeAutomobile: Bool
    dynamic var subscribeElectronics: Bool
    dynamic var subscribeFurniture: Bool
    dynamic var done: Bool

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
