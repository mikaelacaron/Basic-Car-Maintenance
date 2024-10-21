//
//  XCUIApplication-dismissPopup.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import XCTest

extension XCUIApplication {
    func dismissPopup() {
        otherElements["dismiss popup"].tap()
    }
}
