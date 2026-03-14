//
//  MyPrescriptionsViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class MyPrescriptionsViewModel {
    private var db = Firestore.firestore()
    var prescriptions = [Prescription]()
    
    func fetchPrescriptions() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("prescriptions")
            .whereField("userId", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Erro ao buscar receitas: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                self.prescriptions = documents.compactMap { doc -> Prescription? in
                    do {
                        return try doc.data(as: Prescription.self)
                    } catch {
                        print("Erro ao decodificar documento \(doc.documentID): \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }
    
    func deletePrescription(at offsets: IndexSet) {
        offsets.forEach { index in
            let id = prescriptions[index].id ?? ""
            db.collection("prescriptions").document(id).delete()
            self.prescriptions.remove(at: index)
        }
    }
    
    func signOutUser() {
        try? Auth.auth().signOut()
    }
}
