//
//  EditPrescriptionView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI

struct EditPrescriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: EditPrescriptionViewModel
    @State private var showAddMedicineSheet = false
    
    init(prescription: Prescription) {
        _viewModel = State(initialValue: EditPrescriptionViewModel(prescription: prescription))
    }
    
    var body: some View {
        Form {
            Section("Nome da receita") {
                TextField("Ex: Medicação Diária", text: $viewModel.prescriptionName)
            }
            
            Section("Medicamentos") {
                ForEach(viewModel.medicines, id: \.name) { medicine in
                    VStack(alignment: .leading) {
                        Text(medicine.name).font(.headline)
                        Text("\(medicine.dosage) • \(medicine.frequency)")
                            .font(.subheadline).foregroundColor(.secondary)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = viewModel.medicines.firstIndex(where: { $0.name == medicine.name }) {
                                viewModel.removeMedicine(at: IndexSet(integer: index))
                            }
                        } label: {
                            Label("Remover", systemImage: "trash")
                        }
                    }
                }
                
                Button(action: { showAddMedicineSheet = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                        Text("Adicionar medicamento")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle("Editar receita")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    viewModel.updatePrescription { success in
                        if success { dismiss() }
                    }
                }
                .disabled(!viewModel.canSave)
            }
        }
        .sheet(isPresented: $showAddMedicineSheet) {
            AddMedicineView { newMedicine in
                viewModel.addMedicine(newMedicine)
            }
        }
        .overlay {
            if viewModel.isSaving {
                ProgressView().padding().background(.ultraThinMaterial).cornerRadius(10)
            }
        }
    }
}
