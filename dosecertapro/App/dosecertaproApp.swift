//
//  dosecertaproApp.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct dosecertaproApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var coordinator: AppCoordinator
    private let container: DependencyContainer
    
    init() {
        let container = DependencyContainer.createReal()
        self.container = container
        _coordinator = StateObject(wrappedValue: AppCoordinator(
            viewFactory: container,
            stateProvider: container
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                Group {
                    switch coordinator.appState {
                    case .authenticated:
                        coordinator.build(route: .myPrescriptions)
                    case .onboarding:
                        coordinator.build(route: .welcome)
                    case .unauthenticated:
                        coordinator.build(route: .auth)
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.build(route: route)
                }
            }
            .id(coordinator.appState)
            .environmentObject(coordinator)
            .sheet(
                item: Binding(
                    get: { coordinator.sheetRoute },
                    set: { _ in coordinator.dismissSheet() }
            )) { route in
                NavigationStack {
                    coordinator.build(route: route)
                }
                .environmentObject(coordinator)
            }
        }
    }
}
