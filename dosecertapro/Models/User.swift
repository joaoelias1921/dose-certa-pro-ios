//
//  User.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 15/03/26.
//

import FirebaseFirestore

struct User: Codable {
    @DocumentID var uid: String?
    var name: String
    var dateOfBirth: Date
    var email: String
}
