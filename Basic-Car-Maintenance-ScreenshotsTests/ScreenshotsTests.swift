//
//  ScreenshotsTests.swift
//  Basic-Car-Maintenance-ScreenshotsTests
//
//  Created by Thomas Durand on 11/17/2023.
//

import XCTest

@testable import Basic_Car_Maintenance
import ScreenshotKit

final class ScreenshotsTests: XCTestCase {
    @MainActor
    func testMainScreenScreenshot() throws {
        generateScreenshots(for: {
                                MainTabView()
                                    .environment(ActionService.shared)
                                    .withSystemDecoration()
                            },
                            named: "MainScreen",
                            type: .device(.iPhone(orientations: .portrait)),
                            prefix: "BasicCarMaintenance")
    }
}
