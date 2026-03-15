//
//  MockAuthService.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

class MockAuthService: AuthServiceProtocol {
    var signOutCalled = false
    var signInCalled = false
    var signUpCalled = false
    
    func signOut() async throws { signOutCalled = true }
    
    func signIn(email: String, password: String) async throws { signInCalled = true }
    
    func signUp(email: String, password: String) async throws -> String {
        signUpCalled = true
        return "123_user"
    }
}
