//
//  EditPrescriptionView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI

struct EditPrescriptionView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: EditPrescriptionViewModel
    @State private var showAddMedicineSheet = false
    
    init(viewModel: EditPrescriptionViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Form {
            Section("Nome da receita") {
                TextField("Ex: Medicação Diária", text: $viewModel.prescription.name)
            }
            
            Section("Medicamentos") {
                ForEach(viewModel.medicines) { medicine in
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
                    coordinator.dismissSheet()
                    Task {
                        await viewModel.updatePrescription()
                    }
                }
                .disabled(!viewModel.canSave)
            }
        }
        .sheet(isPresented: $showAddMedicineSheet) {
            coordinator.makeAddMedicineView { newMedicine in
                viewModel.addMedicine(newMedicine)
                showAddMedicineSheet = false
            }
        }
        .overlay {
            if viewModel.isSaving {
                ProgressView().padding().background(.ultraThinMaterial).cornerRadius(10)
            }
        }
    }
}

#Preview {
    let container = DependencyContainer.preview
    container.makeEditPrescriptionView(prescription: Prescription(
        id: "1",
        name: "Receita 1",
        medicines: [
            Medicine(
                id: "1",
                name: "Nome do medicamento",
                dosage: "100mg",
                frequency: "8/8",
                observations: "Observações",
                timeToTake: "12:00"
            )
        ],
        userId: "123_user",
        createdAt: "2026-03-14T15:00:00Z",
        updatedAt: "2026-03-14T15:00:00Z"
    ))
}
