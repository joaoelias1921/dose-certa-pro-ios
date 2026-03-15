//
//  AuthView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI

struct AuthView: View {
    @State private var viewModel: AuthViewModel
    var eighteenYearsAgo: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: .now) ?? .now
    }
    
    init(container: DependencyContainer) {
        self._viewModel = State(
            initialValue: AuthViewModel(
                authService: container.authService,
                userService: container.userService
            )
        )
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.isSignUp ? "Crie sua conta" : "Bem vindo")
                        .font(.largeTitle.bold())
                    Text(viewModel.isSignUp ? "Insira seus dados para que possamos personalizar sua experiência" : "Faça login para continuar")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding(.vertical, 16)
                    }
                }
                
                VStack(spacing: 15) {
                    if viewModel.isSignUp {
                        VStack(alignment: .leading) {
                            TextField("Nome Completo", text: $viewModel.name)
                                .textFieldStyle(.roundedBorder)
                            Text("Como aparece em seu documento oficial")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading) {
                            DatePicker(
                                "Data de nascimento",
                                selection: $viewModel.birthDate,
                                in: ...eighteenYearsAgo,
                                displayedComponents: .date
                            )
                            
                            Text("Você deve ter 18 anos ou mais para utilizar o DoseCerta")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("E-mail", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        if viewModel.isSignUp {
                            Text("Para informações e lembretes importantes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        SecureField("Senha", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                        if viewModel.isSignUp {
                            Text("A senha deve conter pelo menos 6 caracteres")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 16)
                
                Button {
                    Task {
                        await viewModel.authenticate()
                    }
                } label: {
                    Text(viewModel.isSignUp ? "Criar conta" : "Entrar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isFormValid)
                
                HStack {
                    Spacer()
                    Button(viewModel.isSignUp ? "Já possui uma conta? Faça login" : "Não possui uma conta? Crie uma agora") {
                        withAnimation {
                            viewModel.errorMessage = ""
                            viewModel.isSignUp.toggle()
                        }
                    }
                    .font(.callout)
                    Spacer()
                }
                .padding(.top, 16)
            }
            .alert("Erro", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
        .padding()
    }
}

#Preview {
    AuthView(container: .preview).environmentObject(AppCoordinator.preview)
}
