//
//  Prescription.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation
import FirebaseFirestore

struct Prescription: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var medicines: [Medicine]
    var userId: String
    var createdAt: String
    var updatedAt: String
}
