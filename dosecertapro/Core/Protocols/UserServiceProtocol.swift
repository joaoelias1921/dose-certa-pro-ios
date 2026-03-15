//
//  UserServiceProtocol.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 15/03/26.
//

protocol UserServiceProtocol {
    func saveUserData(_ userData: User) async throws
}
