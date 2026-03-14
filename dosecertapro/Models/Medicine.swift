//
//  Medicine.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation

struct Medicine: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var name: String
    var dosage: String
    var frequency: String
    var observations: String
    var timeToTake: String
}
