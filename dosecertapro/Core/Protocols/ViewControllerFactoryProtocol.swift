//
//  ViewControllerFactoryProtocol.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 21/03/26.
//

protocol ViewControllerFactoryProtocol {
    func makeWelcomeView() -> WelcomeView
    func makeAuthView() -> AuthView
    func makeMyPrescriptionsView() -> MyPrescriptionsView
    func makeNewPrescriptionView() -> NewPrescriptionView
    func makePrescriptionDetailsView(prescription: Prescription) -> PrescriptionDetailsView
    func makeEditPrescriptionView(prescription: Prescription) -> EditPrescriptionView
    func makeAddMedicineView(onSave: @escaping (Medicine) -> Void) -> AddMedicineView
}
