//
//  VitesseApp.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 10/12/2024.
//

import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if viewModel.isLogged {
                    CandidatesView(viewModel: viewModel.candidatesViewModel)
                } else {
                    LoginView(
                        viewModel: viewModel.authenticationViewModel,
                        registerViewModel: viewModel.registerViewModel
                    )
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                }
            }
        }
    }
}
