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
    private let viewFactory: ViewControllerFactoryProtocol
    private var stateProvider: AppStateProviderProtocol
    
    var appState: AppState {
        if isAuthenticated { return .authenticated }
        if !hasSeenOnboarding { return .onboarding }
        return .unauthenticated
    }
    
    init(viewFactory: ViewControllerFactoryProtocol, stateProvider: AppStateProviderProtocol) {
        self.viewFactory = viewFactory
        self.stateProvider = stateProvider
        self.isAuthenticated = stateProvider.isUserLoggedIn
        self.hasSeenOnboarding = stateProvider.hasSeenOnboarding
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
        stateProvider.hasSeenOnboarding = true
        self.hasSeenOnboarding = true
        push(.auth)
    }
    
    func makeAddMedicineView(onSave: @escaping (Medicine) -> Void) -> AddMedicineView {
        viewFactory.makeAddMedicineView(onSave: onSave)
    }
    
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .welcome:
            viewFactory.makeWelcomeView()
        case .auth:
            viewFactory.makeAuthView()
        case .myPrescriptions:
            viewFactory.makeMyPrescriptionsView()
        case .newPrescription:
            viewFactory.makeNewPrescriptionView()
        case .editPrescription(let prescription):
            viewFactory.makeEditPrescriptionView(prescription: prescription)
        case .prescriptionDetails(let prescription):
            viewFactory.makePrescriptionDetailsView(prescription: prescription)
        }
    }
    
    private func setupAuthListener() {
        stateProvider.listenToAuthState { [weak self] loggedIn in
            Task { @MainActor in
                self?.isAuthenticated = loggedIn
                self?.hasSeenOnboarding = self?.stateProvider.hasSeenOnboarding ?? false
                self?.path = NavigationPath()
            }
        }
    }
}

extension AppCoordinator {
    @MainActor
    static var preview: AppCoordinator {
        let previewContainer = DependencyContainer.preview
        return AppCoordinator(
            viewFactory: previewContainer,
            stateProvider: previewContainer
        )
    }
}

extension AppRoute: Identifiable {
    var id: Int { self.hashValue }
}
