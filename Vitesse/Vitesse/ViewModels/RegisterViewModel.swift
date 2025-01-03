//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 03/01/2025.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    
    private let registerService: RegisterService
    let onRegisterSucceed: () -> Void
    
    init(registerService: RegisterService = RegisterService(),
         _ callback: @escaping () -> Void) {
        self.registerService = registerService
        self.onRegisterSucceed = callback
    }
    
    func register() async {
        do {
            // Basic validation
            guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
                errorMessage = "All fields are required"
                return
            }
            
            guard password == confirmPassword else {
                errorMessage = "Passwords don't match"
                return
            }
            
            try await registerService.register(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )
            
            onRegisterSucceed()
        } catch {
            print(error)
            errorMessage = "Registration failed: \(error.localizedDescription)"
        }
    }
}
