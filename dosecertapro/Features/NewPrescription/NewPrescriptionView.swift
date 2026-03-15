//
//  NewPrescriptionView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI

struct NewPrescriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: NewPrescriptionViewModel
    @State private var showAddMedicineSheet = false
    
    init(container: DependencyContainer) {
        self._viewModel = State(
            initialValue: NewPrescriptionViewModel(
                prescriptionService: container.prescriptionService,
            )
        )
    }
    
    var body: some View {
        Form {
            Section("Nome da receita") {
                TextField("Vitaminas diárias", text: $viewModel.prescriptionName)
            }
            
            Section("Medicamentos") {
                if viewModel.medicines.isEmpty {
                    Text("Você ainda não adicionou nenhum medicamento")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                } else {
                    ForEach(viewModel.medicines) { medicine in
                        medicineRow(medicine)
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
        .navigationTitle("Criar receita")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    Task {
                        if await viewModel.save() {
                            dismiss()
                        }
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
        .alert("Erro", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    @ViewBuilder
    private func medicineRow(_ medicine: Medicine) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "pill")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                Text(medicine.name)
                    .font(.headline)
            }
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "bubbles.and.sparkles")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                Text("\(medicine.dosage) • \(medicine.frequency)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "alarm")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                Text(medicine.timeToTake)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            if !medicine.observations.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    Text(medicine.observations)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.deleteMedicine(medicine)
            } label: {
                Label("Excluir", systemImage: "trash")
            }
        }
    }
}

#Preview {
    NewPrescriptionView(container: .preview)
}
