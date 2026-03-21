//
//  AppCoordinator.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 15/03/26.
//

import SwiftUI
import Combine

enum AppState {
    case authenticated
    case onboarding
    case unauthenticated
}

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
    @Published var hasSeenOnboarding: Bool
    private let container: DependencyContainer
    
    var appState: AppState {
        if isAuthenticated { return .authenticated }
        if !hasSeenOnboarding { return .onboarding }
        return .unauthenticated
    }
    
    init(container: DependencyContainer) {
        self.container = container
        self.isAuthenticated = container.authService.isUserLoggedIn
        self.hasSeenOnboarding = container.onboardingService.hasSeenOnboarding
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
    
    func completeWelcome() {
        container.onboardingService.hasSeenOnboarding = true
        self.hasSeenOnboarding = true
        push(.auth)
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
            PrescriptionDetailsView(container: container, prescription: prescription)
        }
    }
    
    private func setupAuthListener() {
        container.authService.listenToAuthState { [weak self] loggedIn in
            DispatchQueue.main.async {
                self?.isAuthenticated = loggedIn
                
                if let service = self?.container.onboardingService {
                    self?.hasSeenOnboarding = service.hasSeenOnboarding
                }
                
                self?.path = NavigationPath()
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
