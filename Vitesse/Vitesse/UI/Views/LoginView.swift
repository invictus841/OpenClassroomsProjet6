//
//  LoginView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 11/12/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    let registerViewModel: RegisterViewModel
    @State private var showRegisterView = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome Back")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 20) {
                CustomTextField(
                    placeholder: "Enter your email",
                    label: "Email/Username",
                    text: $viewModel.email
                )
                
                CustomTextField(
                    placeholder: "Enter your password",
                    label: "Password",
                    text: $viewModel.password,
                    isSecure: true
                )
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .padding(.top, 4)
                }
                
                SecondaryButton(title: "Forgot password?") {
                    // Forgot password action // Non précisé dans le readme backend
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                PrimaryButton(title: "Sign In") {
                    Task {
                        await viewModel.login()
                    }
                }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    SecondaryButton(title: "Register") {
                        showRegisterView = true
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 60)
        .navigationDestination(isPresented: $showRegisterView) {
            RegisterView(viewModel: RegisterViewModel { registeredEmail in
                viewModel.email = registeredEmail
                showRegisterView = false  // This will dismiss the view
            })
        }
    }
}

#Preview {
    LoginView(
        viewModel: LoginViewModel {_ in 
            print("Login success in preview")
        },
        registerViewModel: RegisterViewModel {_ in 
            print("Register success in preview")
        }
    )
}
