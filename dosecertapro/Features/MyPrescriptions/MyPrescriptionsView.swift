//
//  MyPrescriptionsView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI

struct MyPrescriptionsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var viewModel: MyPrescriptionsViewModel
    @State private var showDeleteAlert = false
    @State private var prescriptionToDelete: Prescription?
    @State private var showAlert = true
    
    init(container: DependencyContainer) {
        self._viewModel = State(
            initialValue: MyPrescriptionsViewModel(
                prescriptionService: container.prescriptionService,
                authService: container.authService
            )
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            if viewModel.prescriptions.isEmpty {
                emptyPrescriptionsView
            } else {
                List {
                    ForEach(viewModel.prescriptions) { prescription in
                        Button(action: { coordinator.push(.prescriptionDetails(prescription)) }) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(prescription.name)
                                    .font(.title3)
                                HStack {
                                    Text("Medicamentos:")
                                        .bold()
                                    Text("\(prescription.medicines.count)")
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Text("Atualizada em:")
                                        .bold()
                                    Text(try! Date(prescription.updatedAt, strategy: .iso8601).formatted(date: .numeric, time: .omitted))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                prescriptionToDelete = prescription
                                showDeleteAlert = true
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            Button(action: { coordinator.push(.newPrescription) }) {
                Image(systemName: "plus")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding()
        }
        .navigationTitle("Minhas receitas")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.signOutUser) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .alert("Excluir receita", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) {
                prescriptionToDelete = nil
            }
            Button("Excluir", role: .destructive) {
                if let prescription = prescriptionToDelete {
                    confirmDelete(prescription)
                }
            }
        } message: {
            Text("Tem certeza que deseja excluir esta receita? \nEsta ação não pode ser desfeita")
        }
        .onAppear {
            viewModel.fetchPrescriptions()
        }
    }
    
    private func confirmDelete(_ prescription: Prescription) {
        if let index = viewModel.prescriptions.firstIndex(where: { $0.id == prescription.id }) {
            viewModel.deletePrescription(at: IndexSet(integer: index))
        }
        prescriptionToDelete = nil
    }
    
    @ViewBuilder
    private var emptyPrescriptionsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "pills.circle")
                .font(.system(size: 100))
                .foregroundColor(.blue.opacity(0.5))
            Text("Você ainda não adicionou nenhuma receita")
                .font(.headline)
            Text("Utilize o botão flutuante abaixo para começar")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MyPrescriptionsView(container: .preview).environmentObject(AppCoordinator.preview)
}
