//
//  FirebaseUserService.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 15/03/26.
//

import FirebaseFirestore

class FirebaseUserService: UserServiceProtocol {
    private lazy var db = Firestore.firestore()
    
    func saveUserData(_ userData: User) async throws {
        guard let userId = userData.uid, !userId.isEmpty else {
            throw NSError(domain: "AppError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Usuário não encontrado"])
        }
        
        let userData: [String: Any] = [
            "uid": userId,
            "name": userData.name,
            "dateOfBirth": userData.dateOfBirth,
            "email": userData.email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        try await db.collection("users").document(userId).setData(userData)
    }
}
