//
//  AddMedicineView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI

struct AddMedicineView: View {
    @State private var name = ""
    @State private var dosage = ""
    @State private var frequency = ""
    @State private var observations = ""
    @State private var selectedTime = Date()
    @Environment(\.dismiss) var dismiss
    var onSave: (Medicine) -> Void

    var body: some View {
        Form {
            Section("Detalhes do medicamento") {
                TextField("Nome", text: $name)
                TextField("Dosagem (ex: 1 comprimido)", text: $dosage)
                TextField("Frequência (ex: 8/8 horas)", text: $frequency)
            }
            
            Section("Horário") {
                DatePicker(
                    "Selecione o horário",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
            }
            
            Section("Observações") {
                TextField("Tomar após refeição", text: $observations)
            }
        }
        .navigationTitle("Novo medicamento")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Adicionar") {
                    let timeString = selectedTime.formatted(date: .omitted, time: .shortened)
                    
                    let medicine = Medicine(
                        name: name,
                        dosage: dosage,
                        frequency: frequency,
                        observations: observations,
                        timeToTake: timeString
                    )
                    onSave(medicine)
                    dismiss()
                }
                .disabled(name.isEmpty || dosage.isEmpty || frequency.isEmpty)
            }
        }
    }
}
