//
//  FirebasePrescriptionService.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import FirebaseFirestore
import FirebaseAuth

class FirebasePrescriptionService: PrescriptionServiceProtocol {
    private lazy var db = Firestore.firestore()
    
    func getCurrentUserID() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    func savePrescription(_ prescription: Prescription) async throws {
        try db.collection("prescriptions").addDocument(from: prescription)
    }
    
    func updatePrescription(_ updatedPrescription: Prescription) async throws {
        guard let prescriptionId = updatedPrescription.id, !prescriptionId.isEmpty else {
            throw NSError(domain: "AppError", code: 400, userInfo: [NSLocalizedDescriptionKey: "ID da receita inválido"])
        }

        let updatedData: [String: Any] = [
            "name": updatedPrescription.name,
            "medicines": updatedPrescription.medicines.map {[
                "id": $0.id,
                "name": $0.name,
                "dosage": $0.dosage,
                "frequency": $0.frequency,
                "observations": $0.observations,
                "timeToTake": $0.timeToTake
            ]},
            "updatedAt": Date().ISO8601Format()
        ]
        try await db.collection("prescriptions").document(prescriptionId).updateData(updatedData)
    }
    
    func observePrescriptions(userId: String, completion: @escaping (Result<[Prescription], Error>) -> Void) {
        db.collection("prescriptions")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let prescriptions = documents.compactMap { doc -> Prescription? in
                    try? doc.data(as: Prescription.self)
                }
                
                completion(.success(prescriptions))
            }
    }
    
    func observeSinglePrescription(id: String, completion: @escaping (Result<Prescription, Error>) -> Void) -> (() -> Void) {
        let listener = db.collection("prescriptions")
            .document(id)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = documentSnapshot, document.exists, let prescription = try? document.data(as: Prescription.self) else {
                    return
                }
                
                completion(.success(prescription))
            }
        
        return { listener.remove() }
    }
    
    func deletePrescription(id: String) async throws {
        try await db.collection("prescriptions").document(id).delete()
    }
}
