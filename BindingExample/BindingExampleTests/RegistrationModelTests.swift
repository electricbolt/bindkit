/*******************************************************************************
 * RegistrationModelTests.h                                                    *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

import Foundation;
import XCTest;
@testable import BindingExample;

/**
 Example XCTestCase showing that you can unit test a model object.
 */
class RegistrationModelTests: XCTestCase {

    var model: RegistrationModel!

    override func setUp() {
        super.setUp()
        model = RegistrationModel()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValidate() {
        model.firstName = ""
        model.lastName = ""
        model.email = ""
        model.inputAge = 0
        model.subscribeFurniture = false
        model.subscribeAutomobile = false
        model.subscribeElectronics = false
        XCTAssertFalse(model.validate())

        model.firstName = "Abc"
        XCTAssertFalse(model.validate())

        model.lastName = "Def"
        XCTAssertFalse(model.validate())

        model.email = "abc@def.com"
        XCTAssertFalse(model.validate())

        model.inputAge = 18.0
        XCTAssertFalse(model.validate())

        model.subscribeFurniture = true
        XCTAssertTrue(model.validate())
    }

}

