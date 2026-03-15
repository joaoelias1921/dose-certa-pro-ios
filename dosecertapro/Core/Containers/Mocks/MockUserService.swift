//
//  MockUserService.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 15/03/26.
//

class MockUserService: UserServiceProtocol {
    var saveCalled = false
    
    func saveUserData(_ userData: User) async throws {
        saveCalled = true
    }
}
