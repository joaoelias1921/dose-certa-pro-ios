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
    var isUserLoggedIn: Bool = false
    
    func listenToAuthState(completion: @escaping (Bool) -> Void) {
        isUserLoggedIn = !isUserLoggedIn
    }
    
    func signOut() async throws {
        signOutCalled = true
        isUserLoggedIn = false
    }
    
    func signIn(email: String, password: String) async throws {
        signInCalled = true
        isUserLoggedIn = true
    }
    
    func signUp(email: String, password: String) async throws -> String {
        signUpCalled = true
        isUserLoggedIn = true
        return "123_user"
    }
}
