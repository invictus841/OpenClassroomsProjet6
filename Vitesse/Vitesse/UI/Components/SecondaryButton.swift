//
//  SecondaryButton.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 08/01/2025.
//
import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.blue)
                .padding(.vertical, 8)
        }
    }
}

#Preview {
    VStack {
        SecondaryButton(title: "Forgot Password?") {}
        SecondaryButton(title: "Register") {}
    }
    .padding()
}
