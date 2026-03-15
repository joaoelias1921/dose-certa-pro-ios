//
//  EditPrescriptionViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI
import Foundation

@Observable
@MainActor
class EditPrescriptionViewModel {
    private let prescriptionService: PrescriptionServiceProtocol
    var prescription: Prescription
    var isSaving = false
    var errorMessage: String?
    var medicines: [Medicine] { prescription.medicines }
    
    init(
        prescription: Prescription,
        prescriptionService: PrescriptionServiceProtocol
    ) {
        self.prescription = prescription
        self.prescriptionService = prescriptionService
    }
    
    var canSave: Bool {
        !prescription.name.isEmpty && !prescription.medicines.isEmpty && !isSaving
    }
    
    func addMedicine(_ medicine: Medicine) {
        prescription.medicines.append(medicine)
    }
    
    func removeMedicine(at offsets: IndexSet) {
        prescription.medicines.remove(atOffsets: offsets)
    }
    
    func updatePrescription() async -> Bool {
        isSaving = true
        defer { isSaving = false }
        
        do {
            try await prescriptionService.updatePrescription(prescription)
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}
