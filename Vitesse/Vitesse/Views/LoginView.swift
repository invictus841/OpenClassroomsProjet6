//
//  LoginView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 11/12/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email/Username")
                    .foregroundColor(.gray)
                TextField("", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .foregroundColor(.gray)
                SecureField("", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Button(action: {
                            // No action as it's not in requirements
                        }) {
                            Text("Forgot password?")
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                // Navigate to register screen
            }) {
                Text("Register")
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.top, 60)
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel {})
}
