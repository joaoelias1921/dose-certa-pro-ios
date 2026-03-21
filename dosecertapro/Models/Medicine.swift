//
//  Medicine.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation

struct Medicine: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var dosage: String
    var frequency: String
    var observations: String
    var timeToTake: String
    
    init(
        id: String = UUID().uuidString,
        name: String,
        dosage: String,
        frequency: String,
        observations: String,
        timeToTake: String
    ) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.observations = observations
        self.timeToTake = timeToTake
    }
}
