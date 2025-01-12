//
//  AuthViewModel.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    private let loginService: LoginService
    private let tokenStore: TokenStore
    let onLoginSucceed: (Bool) -> Void
    
    init(loginService: LoginService = LoginService(),
         tokenStore: TokenStore = KeychainStore(),
         _ callback: @escaping (Bool) -> Void) {
        self.loginService = loginService
        self.tokenStore = tokenStore
        self.onLoginSucceed = callback
    }
    
    @MainActor
    func login() async {
        guard !email.isEmpty || !password.isEmpty else {
            errorMessage = "Email and password cannot be empty"
            return
        }
        
        do {
            let request = try LoginEndpoint.loginRequest(email: email, password: password)
            let (token, isAdmin) = try await loginService.login(with: request)
            print("Login successful - isAdmin: \(isAdmin)")
            try tokenStore.insert(token.data(using: String.Encoding.utf8) ?? Data())
            onLoginSucceed(isAdmin)
        } catch {
            print(error)
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }
}
