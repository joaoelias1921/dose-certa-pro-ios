//
//  AuthViewModel.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import Foundation

@Observable
@MainActor
class AuthViewModel {
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    var email = ""
    var password = ""
    var name = ""
    var birthDate: Date
    var isSignUp = false
    var errorMessage = ""
    var showAlert = false
    
    init(
        authService: AuthServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.authService = authService
        self.userService = userService
        self.birthDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    }
    
    var isFormValid: Bool {
        if isSignUp {
            return !name.isEmpty && !email.isEmpty && password.count >= 6 && email.contains("@")
        }
        return !email.isEmpty && !password.isEmpty
    }
    
    func authenticate() async {
        if isSignUp {
            await signUp()
            return
        }
        await login()
    }
    
    private func signUp() async {
        do {
            let userId = try await authService.signUp(email: email, password: password)
            try await userService.saveUserData(User(
                uid: userId,
                name: self.name,
                dateOfBirth: self.birthDate,
                email: self.email,
            ))
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func login() async {
        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
