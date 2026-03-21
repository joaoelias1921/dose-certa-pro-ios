//
//  DependencyContainer.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

final class DependencyContainer: ViewControllerFactoryProtocol, AppStateProviderProtocol {
    let prescriptionService: PrescriptionServiceProtocol
    let userService: UserServiceProtocol
    let authService: AuthServiceProtocol
    var onboardingService: OnboardingServiceProtocol
    var isUserLoggedIn: Bool { authService.isUserLoggedIn }
    var hasSeenOnboarding: Bool {
        get { onboardingService.hasSeenOnboarding }
        set { onboardingService.hasSeenOnboarding = newValue }
    }
    
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
    
    func listenToAuthState(completion: @escaping (Bool) -> Void) {
        authService.listenToAuthState(completion: completion)
    }
    
    @MainActor
    func makeWelcomeView() -> WelcomeView {
        return WelcomeView()
    }
    
    @MainActor
    func makeAuthView() -> AuthView {
        let viewModel = AuthViewModel(authService: authService, userService: userService)
        return AuthView(viewModel: viewModel)
    }
    
    @MainActor
    func makeMyPrescriptionsView() -> MyPrescriptionsView {
        let viewModel = MyPrescriptionsViewModel(
            prescriptionService: prescriptionService,
            authService: authService
        )
        return MyPrescriptionsView(viewModel: viewModel)
    }
    
    @MainActor
    func makeNewPrescriptionView() -> NewPrescriptionView {
        let viewModel = NewPrescriptionViewModel(prescriptionService: prescriptionService)
        return NewPrescriptionView(viewModel: viewModel)
    }
    
    @MainActor
    func makePrescriptionDetailsView(prescription: Prescription) -> PrescriptionDetailsView {
        let viewModel = PrescriptionDetailsViewModel(
            prescriptionService: prescriptionService,
            prescription: prescription
        )
        return PrescriptionDetailsView(viewModel: viewModel)
    }
    
    @MainActor
    func makeEditPrescriptionView(prescription: Prescription) -> EditPrescriptionView {
        let viewModel = EditPrescriptionViewModel(
            prescription: prescription,
            prescriptionService: prescriptionService
        )
        return EditPrescriptionView(viewModel: viewModel)
    }
    
    @MainActor
    func makeAddMedicineView(onSave: @escaping (Medicine) -> Void) -> AddMedicineView {
        return AddMedicineView(onSave: onSave)
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
        let mockOnboardingService = MockOnboardingService()
        
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
            userService: mockUserService,
            onboardingService: mockOnboardingService
        )
    }
}
