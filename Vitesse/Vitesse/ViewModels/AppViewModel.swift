//
//  AppViewModel.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 03/01/2025.
//

import Foundation

final class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    
    init() {
        isLogged = false
    }
    
    var authenticationViewModel: LoginViewModel {
        return LoginViewModel { [weak self] in
            DispatchQueue.main.async {  // Thread safety here
                self?.isLogged = true
            }
        }
    }
    
    var registerViewModel: RegisterViewModel {
            return RegisterViewModel {
                // After successful registration, we could either:
                // 1. Automatically log them in (would need to modify RegisterService to return a token)
                // 2. Take them back to login screen
                print("Registration successful")
                // For now, let's just take them back to login
            }
        }
}
