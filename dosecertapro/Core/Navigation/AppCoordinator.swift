//
//  AppCoordinator.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 15/03/26.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case welcome
    case auth
    case myPrescriptions
    case newPrescription
    case editPrescription(Prescription)
    case prescriptionDetails(Prescription)
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isAuthenticated: Bool = false
    @Published var sheetRoute: AppRoute?
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
        self.isAuthenticated = container.authService.isUserLoggedIn
        setupAuthListener()
    }
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func presentSheet(_ route: AppRoute) {
        self.sheetRoute = route
    }
    
    func dismissSheet() {
        self.sheetRoute = nil
    }
    
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .welcome:
            WelcomeView()
        case .auth:
            AuthView(container: container)
        case .myPrescriptions:
            MyPrescriptionsView(container: container)
        case .newPrescription:
            NewPrescriptionView(container: container)
        case .editPrescription(let prescription):
            EditPrescriptionView(container: container, prescription: prescription)
        case .prescriptionDetails(let prescription):
            PrescriptionDetailsView(prescription: prescription)
        }
    }
    
    private func setupAuthListener() {
        container.authService.listenToAuthState { [weak self] loggedIn in
            print("DEBUG: Auth state changed. LoggedIn: \(loggedIn)")
            DispatchQueue.main.async {
                if loggedIn {
                    self?.path = NavigationPath()
                }
                self?.isAuthenticated = loggedIn
                if !loggedIn {
                    self?.path = NavigationPath()
                }
            }
        }
    }
}

extension AppCoordinator {
    @MainActor
    static var preview: AppCoordinator {
        return AppCoordinator(container: .preview)
    }
}

extension AppRoute: Identifiable {
    var id: Int { self.hashValue }
}
