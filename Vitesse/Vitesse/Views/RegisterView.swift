//
//  RegisterView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 11/12/2024.
//

import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Register")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("First Name")
                    .foregroundColor(.gray)
                TextField("", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Last Name")
                    .foregroundColor(.gray)
                TextField("", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
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
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirm Password")
                    .foregroundColor(.gray)
                SecureField("", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            Button(action: {
                // account create logic
            }) {
                Text("Create")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.top, 60)
    }
}

#Preview {
    RegisterView()
}
