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
    
    private let authenticator: LoginService
    private let tokenStore: TokenStore
    let onLoginSucceed: () -> Void
    
    init(authenticator: LoginService = LoginService(),
         tokenStore: TokenStore = KeychainStore(),
         _ callback: @escaping () -> Void) {
        self.authenticator = authenticator
        self.tokenStore = tokenStore
        self.onLoginSucceed = callback
    }
    
    func login() async {
        do {
            let request = try LoginEndpoint.loginRequest(email: email, password: password)
            let token = try await authenticator.requestToken(from: request)
            try tokenStore.insert(token.data(using: .utf8) ?? Data())
            onLoginSucceed()
        } catch {
            print(error)
        }
    }
}
