//
//  AuthServiceProtocol.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws -> String
    func signOut() async throws
}
