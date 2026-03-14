//
//  PrescriptionDetailsView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI

struct PrescriptionDetailsView: View {
    @State private var showEditSheet = false
    let prescription: Prescription
    
    var body: some View {
        List {
            Section(header: Text("Medicamentos")) {
                ForEach(prescription.medicines, id: \.name) { medicine in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(medicine.name)
                            .font(.title3.bold())
                        
                        HStack {
                            DetailRow(icon: "pills.fill", text: medicine.dosage)
                            Spacer()
                            DetailRow(icon: "alarm.fill", text: medicine.timeToTake)
                        }
                        DetailRow(icon: "clock.fill", text: medicine.frequency)
                        
                        if !medicine.observations.isEmpty {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 16))
                                    .foregroundColor(.blue)
                                    .frame(width: 24, alignment: .center)
                                Text(medicine.observations)
                                    .font(.footnote)
                                    .italic()
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle(prescription.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") {
                    showEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                EditPrescriptionView(prescription: prescription)
            }
        }
    }
    
    @ViewBuilder
    private func DetailRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24, alignment: .center)
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    PrescriptionDetailsView(prescription: Prescription(
        id: "1234",
        name: "Receita do Dr. Alex",
        medicines: [
            Medicine(
                name: "Ibuprofeno",
                dosage: "200mg",
                frequency: "2 vezes ao dia",
                observations: "Tomar após refeição",
                timeToTake: "00:00"
            ),
            Medicine(
                name: "Dipirona",
                dosage: "1g",
                frequency: "1 vez ao dia",
                observations: "",
                timeToTake: "12:00"
            ),
            Medicine(
                name: "Ciprofloxacino",
                dosage: "400mg",
                frequency: "1 vez ao dia",
                observations: "Tomar após refeição",
                timeToTake: "08:00"
            ),
        ],
        userId: "1",
        createdAt: "22/12/2025",
        updatedAt: "22/12/2025")
    )
}
