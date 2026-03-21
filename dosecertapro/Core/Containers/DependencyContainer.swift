//
//  DependencyContainer.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

final class DependencyContainer {
    let prescriptionService: PrescriptionServiceProtocol
    let authService: AuthServiceProtocol
    let userService: UserServiceProtocol
    var onboardingService: OnboardingServiceProtocol
    
    init(
        prescriptionService: PrescriptionServiceProtocol = FirebasePrescriptionService(),
        authService: AuthServiceProtocol = FirebaseAuthService(),
        userService: UserServiceProtocol = FirebaseUserService(),
        onboardingService: OnboardingServiceProtocol = OnboardingService()
    ) {
        self.prescriptionService = prescriptionService
        self.authService = authService
        self.userService = userService
        self.onboardingService = onboardingService
    }
}

extension DependencyContainer {
    static func createReal() -> DependencyContainer {
        return DependencyContainer(
            prescriptionService: FirebasePrescriptionService(),
            authService: FirebaseAuthService(),
            userService: FirebaseUserService(),
            onboardingService: OnboardingService()
        )
    }
    
    @MainActor
    static var preview: DependencyContainer {
        let mockPrescriptionService = MockPrescriptionService()
        let mockAuthService = MockAuthService()
        let mockUserService = MockUserService()
        
        mockPrescriptionService.mockPrescriptions = [
            Prescription(
                id: "1",
                name: "Receita de Exemplo",
                medicines: [
                    Medicine(
                        id: "1",
                        name: "Nome do medicamento",
                        dosage: "100mg",
                        frequency: "8/8",
                        observations: "Observações",
                        timeToTake: "12:00"
                    )
                ],
                userId: "123",
                createdAt: "2026-03-14T15:00:00Z",
                updatedAt: "2026-03-14T15:00:00Z"
            )
        ]
        
        return DependencyContainer(
            prescriptionService: mockPrescriptionService,
            authService: mockAuthService,
            userService: mockUserService
        )
    }
}
