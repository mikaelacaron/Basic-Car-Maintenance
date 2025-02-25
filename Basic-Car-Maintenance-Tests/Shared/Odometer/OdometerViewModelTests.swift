//
//  OdometerViewModelTests.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Testing
@testable import Basic_Car_Maintenance

struct OdometerViewModelTests {

    @Test func viewModelInitialState() throws {
        let testUser = "testUser"
        let viewModel = OdometerViewModel(userUID: testUser)
        
        #expect(viewModel.userUID == testUser)
        
        #expect(viewModel.readings.isEmpty)
        #expect(viewModel.vehicles.isEmpty)
        #expect(viewModel.errorMessage.isEmpty)
        #expect(viewModel.showAddErrorAlert == false)
        #expect(viewModel.isShowingAddOdometerReading == false)
        #expect(viewModel.showEditErrorAlert == false)
        #expect(viewModel.isShowingEditReadingView == false)
    }

    @Test func addReading() {
        
    }
}
