//
//  UserDefaultsOnboardingService.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 21/03/26.
//

import Foundation

class OnboardingService: OnboardingServiceProtocol {
    private let kHasSeenOnboarding = "hasSeenOnboarding"
    
    var hasSeenOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: kHasSeenOnboarding) }
        set { UserDefaults.standard.set(newValue, forKey: kHasSeenOnboarding)}
    }
}
