//
//  NewPrescriptionViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
class NewPrescriptionViewModel {
    private let db = Firestore.firestore()
    var prescriptionName = ""
    var medicines: [Medicine] = []
    var isSaving = false
    var errorMessage: String?
    
    var canSave: Bool {
        !prescriptionName.isEmpty && !medicines.isEmpty && !isSaving
    }
    
    func addMedicine(_ medicine: Medicine) {
        if !medicines.contains(where: { $0.name.lowercased() == medicine.name.lowercased() }) {
            medicines.append(medicine)
            return
        }
        errorMessage = "Este medicamento já foi adicionado"
    }
    
    func deleteMedicine(_ medicine: Medicine) {
        medicines.removeAll { $0.id == medicine.id }
    }
    
    func save (completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isSaving = true
        
        let newPrescription = Prescription(
            id: nil,
            name: prescriptionName,
            medicines: medicines,
            userId: uid,
            createdAt: Date().ISO8601Format(),
            updatedAt: Date().ISO8601Format()
        )
        
        do {
            try db.collection("prescriptions").addDocument(from: newPrescription) { error in
                self.isSaving = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                    return
                }
                completion(true)
            }
        } catch {
            self.isSaving = false
            self.errorMessage = "Erro ao processar os dados da receita."
            completion(false)
        }
    }
}
