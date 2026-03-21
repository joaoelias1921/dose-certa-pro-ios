//
//  PrescriptionServiceProtocol.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

protocol PrescriptionServiceProtocol {
    func observePrescriptions(userId: String, completion: @escaping (Result<[Prescription], Error>) -> Void)
    func observeSinglePrescription(id: String, completion: @escaping (Result<Prescription, Error>) -> Void) -> (() -> Void)
    func savePrescription(_ prescription: Prescription) async throws
    func updatePrescription(_ updatedPrescription: Prescription) async throws
    func deletePrescription(id: String) async throws
    func getCurrentUserID() -> String?
}
