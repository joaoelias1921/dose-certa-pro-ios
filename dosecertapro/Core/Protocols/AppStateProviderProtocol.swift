//
//  AppStateProviderProtocol.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 21/03/26.
//

protocol AppStateProviderProtocol {
    var isUserLoggedIn: Bool { get }
    var hasSeenOnboarding: Bool { get set }
    func listenToAuthState(completion: @escaping (Bool) -> Void)
}
