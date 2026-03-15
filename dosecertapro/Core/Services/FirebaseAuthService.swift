//
//  FirebaseAuthService.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import FirebaseAuth

class FirebaseAuthService: AuthServiceProtocol {
    func signIn(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }
    
    func signUp(email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result.user.uid
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    private func mapAuthError(_ error: NSError) -> AppError {
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .signUpInvalidCredentials
        case AuthErrorCode.invalidCredential.rawValue,
            AuthErrorCode.wrongPassword.rawValue,
            AuthErrorCode.userNotFound.rawValue:
            return .signInInvalidCredentials
        default:
            return .unknown
        }
    }
}

enum AppError: Error, LocalizedError {
    case signInInvalidCredentials
    case signUpInvalidCredentials
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .signUpInvalidCredentials: return "O formato do e-mail é inválido"
        case .signInInvalidCredentials: return "Usuário ou senha incorretos."
        case .unknown: return "Algo deu errado. Tente novamente."
        }
    }
}
