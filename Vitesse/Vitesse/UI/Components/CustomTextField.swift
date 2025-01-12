//
//  CustomTextField.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 08/01/2025.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    let label: String
    @Binding var text: String
    var isSecure: Bool = false
    var contentType: UITextContentType? = .none
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .textContentType(.none)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .textContentType(contentType)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(
            placeholder: "Enter your email",
            label: "Email",
            text: .constant("")
        )
        
        CustomTextField(
            placeholder: "Enter your password",
            label: "Password",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding()
}
