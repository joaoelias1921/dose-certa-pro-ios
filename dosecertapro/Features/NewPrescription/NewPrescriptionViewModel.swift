//
//  NewPrescriptionViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation

@Observable
class NewPrescriptionViewModel {
    private let prescriptionService: PrescriptionServiceProtocol
    var prescriptionName = ""
    var medicines: [Medicine] = []
    var isSaving = false
    var errorMessage: String?
    
    init(prescriptionService: PrescriptionServiceProtocol = FirebasePrescriptionService()) {
        self.prescriptionService = prescriptionService
    }
    
    var canSave: Bool {
        !prescriptionName.isEmpty && !medicines.isEmpty && !isSaving
    }
    
    func addMedicine(_ medicine: Medicine) {
        let isDuplicate = medicines.contains { $0.name.lowercased() == medicine.name.lowercased() }
        
        guard !isDuplicate else {
            errorMessage = "Este medicamento já foi adicionado"
            return
        }
        medicines.append(medicine)
    }
    
    func deleteMedicine(_ medicine: Medicine) {
        medicines.removeAll { $0.id == medicine.id }
    }
    
    @MainActor
    func save() async -> Bool {
        guard let uid = prescriptionService.getCurrentUserID() else {
            errorMessage = "Usuário não autenticado"
            return false
        }
        
        isSaving = true
        defer { isSaving = false }
        
        let prescription = Prescription(
            id: nil,
            name: prescriptionName,
            medicines: medicines,
            userId: uid,
            createdAt: Date().ISO8601Format(),
            updatedAt: Date().ISO8601Format()
        )
        
        do {
            try await prescriptionService.savePrescription(prescription)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
