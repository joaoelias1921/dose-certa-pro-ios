//
//  AuthViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class AuthViewModel {
    private var db = Firestore.firestore()
    var email = ""
    var password = ""
    var name = ""
    var birthDate = Date()
    var isSignUp = false
    var errorMessage = ""
    var showAlert = false
    
    var isFormValid: Bool {
        if isSignUp {
            return !name.isEmpty && !email.isEmpty && password.count >= 6 && email.contains("@")
        }
        return !email.isEmpty && !password.isEmpty
    }
    
    func authenticate() {
        if isSignUp {
            signUp()
            return
        }
        login()
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case AuthErrorCode.invalidEmail.rawValue:
                    self.errorMessage = "O formato do e-mail é inválido"
                    return
                default:
                    self.errorMessage = "Algo deu errado por aqui. Verifique os dados e tente novamente"
                    return
                }
            }
            
            guard let uid = result?.user.uid else { return }
            
            let userData: [String: Any] = [
                "uid": uid,
                "name": self.name,
                "dateOfBirth": self.birthDate,
                "email": self.email,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    self.errorMessage = "Erro ao criar usuário: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
    
    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let error = error else { return }
            
            let message: String
            let code = (error as NSError).code
            
            switch code {
            case AuthErrorCode.invalidCredential.rawValue,
                AuthErrorCode.wrongPassword.rawValue,
                AuthErrorCode.userNotFound.rawValue,
                AuthErrorCode.invalidEmail.rawValue:
                message = "Usuário ou senha incorretos. Tente novamente."
            default:
                message = "Algo deu errado. Tente novamente mais tarde."
            }
            DispatchQueue.main.async {
                self.errorMessage = message
            }
        }
    }
}
