//
//  MyPrescriptionsViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation

@Observable
class MyPrescriptionsViewModel {
    private let prescriptionService: PrescriptionServiceProtocol
    private let authService: AuthServiceProtocol
    var prescriptions = [Prescription]()
    var errorMessage: String?
    
    init(
        prescriptionService: PrescriptionServiceProtocol = FirebasePrescriptionService(),
        authService: AuthServiceProtocol = FirebaseAuthService()
    ) {
        self.prescriptionService = prescriptionService
        self.authService = authService
    }
    
    @MainActor
    func fetchPrescriptions() {
        guard let uid = prescriptionService.getCurrentUserID() else {
            self.errorMessage = "Usuário não autenticado."
            return
        }
        
        prescriptionService.observePrescriptions(userId: uid) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let fetchedPrescriptions):
                    self?.prescriptions = fetchedPrescriptions
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    @MainActor
    func deletePrescription(at offsets: IndexSet) {
        offsets.forEach { index in
            let prescription = prescriptions[index]
            guard let id = prescription.id else { return }
            let removedItem = prescriptions.remove(at: index)
            Task {
                do {
                    try await prescriptionService.deletePrescription(id: id)
                } catch {
                    self.prescriptions.insert(removedItem, at: index)
                    errorMessage = "Não foi possível excluir: \(error.localizedDescription)"
                }
            }
        }
    }
    
    @MainActor
    func signOutUser() {
        Task {
            do {
                try await authService.signOut()
                self.prescriptions = []
                self.errorMessage = nil
            } catch {
                self.errorMessage = "Erro ao sair: \(error.localizedDescription)"
            }
        }
    }
}
