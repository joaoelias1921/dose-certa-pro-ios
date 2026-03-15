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
    @StateObject private var coordinator = AppCoordinator(container: .createReal())
    
    var body: some Scene {
        WindowGroup {
            Group {
                if coordinator.isAuthenticated {
                    NavigationStack(path: $coordinator.path) {
                        coordinator
                            .build(route: .myPrescriptions)
                            .navigationDestination(for: AppRoute.self) { route in
                                coordinator.build(route: route)
                            }
                    }
                    .id("authenticated")
                } else {
                    NavigationStack(path: $coordinator.path) {
                        coordinator
                            .build(route: .welcome)
                            .navigationDestination(for: AppRoute.self) { route in
                                coordinator.build(route: route)
                            }
                    }
                    .id("unauthenticated")
                }
            }
            .environmentObject(coordinator)
            .sheet(
                item: Binding(
                    get: { coordinator.sheetRoute },
                    set: { _ in coordinator.dismissSheet() }
            )) { route in
                NavigationStack {
                    coordinator.build(route: route)
                }
            }
        }
    }
}
