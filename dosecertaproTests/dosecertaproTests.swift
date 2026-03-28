//
//  dosecertaproTests.swift
//  dosecertaproTests
//
//  Created by João Elias Cândido Reis on 28/03/26.
//

import XCTest
@testable import dosecertapro
internal import SwiftUI

final class DoseCertaProTests: XCTestCase {
    var sutViewModel: EditPrescriptionViewModel!
    var mockService: MockPrescriptionService!
    var sutCoordinator: AppCoordinator!
    var mockContainer: DependencyContainer!
    let medicineMock = Medicine(
        name: "Dipirona",
        dosage: "500mg",
        frequency: "8h",
        observations: "",
        timeToTake: "08:00"
    )

    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockPrescriptionService()
        mockContainer = .preview
        
        sutViewModel = EditPrescriptionViewModel(
            prescription: Prescription(
                id: "test",
                name: "User",
                medicines: [],
                userId: "123-456",
                createdAt: "",
                updatedAt: ""
            ),
            prescriptionService: mockService
        )
        
        sutCoordinator = AppCoordinator(
            viewFactory: mockContainer,
            stateProvider: mockContainer
        )
    }

    override func tearDown() {
        sutViewModel = nil
        mockService = nil
        sutCoordinator = nil
        mockContainer = nil
        super.tearDown()
    }
    
    @MainActor func testSaveButtonDisabledWhenFieldsAreEmpty() {
        sutViewModel.prescription.name = ""
        XCTAssertFalse(sutViewModel.canSave, "O botão salvar não deve estar ativo sem nome.")
    }
    
    @MainActor func testAddingMedicineIncreasesCount() {
        let initialCount = sutViewModel.medicines.count
        sutViewModel.addMedicine(medicineMock)
        XCTAssertEqual(sutViewModel.medicines.count, initialCount + 1)
        XCTAssertEqual(sutViewModel.medicines.last?.name, "Dipirona")
    }
    
    @MainActor func testCoordinatorPushIncreasesPath() {
        let initialPathCount = sutCoordinator.path.count
        sutCoordinator.push(.auth)
        XCTAssertEqual(sutCoordinator.path.count, initialPathCount + 1)
    }
    
    @MainActor func testCoordinatorStateReflectsAuth() {
        sutCoordinator.isAuthenticated = true
        XCTAssertEqual(sutCoordinator.appState, .authenticated)
    }
    
    @MainActor func testRemovingMedicineDecreasesCount() {
        sutViewModel.addMedicine(medicineMock)
        let countAfterAdd = sutViewModel.medicines.count
        sutViewModel.removeMedicine(at: IndexSet(integer: 0))
        XCTAssertEqual(sutViewModel.medicines.count, countAfterAdd - 1)
    }
}
