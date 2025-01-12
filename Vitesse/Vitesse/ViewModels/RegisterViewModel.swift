//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 01/01/2025.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var shouldDismiss = false
    
    private let registerService: RegisterService
    let onRegisterSucceed: (String) -> Void  // Modified to pass email
    
    init(registerService: RegisterService = RegisterService(),
         onRegisterSucceed: @escaping (String) -> Void) {
        self.registerService = registerService
        self.onRegisterSucceed = onRegisterSucceed
    }
    
    @MainActor
    func register() async {
        do {
            guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
                errorMessage = "All fields are required"
                successMessage = nil
                return
            }
            
            guard password == confirmPassword else {
                errorMessage = "Passwords don't match"
                successMessage = nil
                return
            }
            
            try await registerService.register(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )
            
            errorMessage = nil
            successMessage = "Registration successful! You can now login."
            onRegisterSucceed(email)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.shouldDismiss = true
            }
            
        } catch {
            print(error)
            errorMessage = "Registration failed: \(error.localizedDescription)"
            successMessage = nil
        }
    }
}
