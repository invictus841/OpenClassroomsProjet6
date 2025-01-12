//
//  AppViewModel.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 03/01/2025.
//

import Foundation

final class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    @Published var isAdmin: Bool
    
    init() {
        isLogged = false
        isAdmin = false
    }
    
    var authenticationViewModel: LoginViewModel {
        return LoginViewModel { [weak self] isAdmin in
            DispatchQueue.main.async {
                print("Login successful - Setting isAdmin to: \(isAdmin)")
                self?.isLogged = true
                self?.isAdmin = isAdmin
            }
        }
    }
    
    var registerViewModel: RegisterViewModel {
        return RegisterViewModel {_ in 
            print("Registration successful")
        }
    }
    
    var candidatesViewModel: CandidateViewModel {
        return CandidateViewModel(isAdmin: isAdmin)
    }
}
