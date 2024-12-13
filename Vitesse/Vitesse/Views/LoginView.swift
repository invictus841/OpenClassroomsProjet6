//
//  LoginView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 11/12/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email/Username")
                    .foregroundColor(.gray)
                TextField("", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .foregroundColor(.gray)
                SecureField("", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            Button(action: {
                // oubli mdp
            }) {
                Text("Forgot password?")
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Button(action: {
                // sign in logic
            }) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Button(action: {
                // register logic
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
    LoginView()
}
