//
//  PrescriptionDetailsViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 21/03/26.
//

import Foundation

@Observable
class PrescriptionDetailsViewModel {
    private let prescriptionService: PrescriptionServiceProtocol
    private var cancelListener: (() -> Void)?
    var prescription: Prescription
    
    init(prescriptionService: PrescriptionServiceProtocol, prescription: Prescription) {
        self.prescriptionService = prescriptionService
        self.prescription = prescription
        startListening()
    }
    
    func startListening() {
        guard let id = prescription.id else { return }
        
        self.cancelListener = prescriptionService.observeSinglePrescription(id: id) { [weak self] result in
            if case .success(let updatedPrescription) = result {
                Task { @MainActor in
                    self?.prescription = updatedPrescription
                }
            }
        }
    }
    
    deinit { cancelListener?() }
}
