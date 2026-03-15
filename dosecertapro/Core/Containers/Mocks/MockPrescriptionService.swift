//
//  MockPrescriptionService.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

class MockPrescriptionService: PrescriptionServiceProtocol {
    var saveCalled = false
    var deleteCalled = false
    var updateCalled = false
    var mockPrescriptions: [Prescription] = [
        Prescription(
            id: "1",
            name: "Dipirona",
            medicines: [],
            userId: "123",
            createdAt: "05/11/2025",
            updatedAt: ""
        )
    ]
    
    func getCurrentUserID() -> String? { "user_123" }
    
    func observePrescriptions(userId: String, completion: @escaping (Result<[Prescription], any Error>) -> Void) {
        completion(.success(mockPrescriptions))
    }
    
    func deletePrescription(id: String) async throws {
        deleteCalled = true
    }
    
    func savePrescription(_ prescription: Prescription) async throws {
        saveCalled = true
    }
    
    func updatePrescription(_ updatedPrescription: Prescription) async throws {
        updateCalled = true
    }
}
