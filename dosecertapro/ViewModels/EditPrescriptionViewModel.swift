//
//  EditPrescriptionViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import Observation

@Observable
class EditPrescriptionViewModel {
    private let prescriptionId: String
    private let db = Firestore.firestore()
    var prescriptionName: String
    var medicines: [Medicine]
    var isSaving = false
    var errorMessage: String?
    
    init(prescription: Prescription) {
        self.prescriptionId = prescription.id ?? ""
        self.prescriptionName = prescription.name
        self.medicines = prescription.medicines
    }
    
    var canSave: Bool {
        !prescriptionName.isEmpty && !medicines.isEmpty && !isSaving
    }
    
    func addMedicine(_ medicine: Medicine) {
        medicines.append(medicine)
    }
    
    func removeMedicine(at offsets: IndexSet) {
        medicines.remove(atOffsets: offsets)
    }
    
    func updatePrescription(completion: @escaping (Bool) -> Void) {
        isSaving = true
        
        let updatedData: [String: Any] = [
            "name": prescriptionName,
            "medicines": medicines.map {[
                "id": $0.id ?? UUID().uuidString,
                "name": $0.name,
                "dosage": $0.dosage,
                "frequency": $0.frequency,
                "observations": $0.observations,
                "timeToTake": $0.timeToTake
            ]},
            "updatedAt": Date().ISO8601Format()
        ]
        
        db.collection("prescriptions").document(prescriptionId).updateData(updatedData) { error in
            self.isSaving = false
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            completion(true)
        }
    }
}
