//
//  PrimaryButton.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 08/01/2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(10)
                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
}

#Preview {
    VStack {
        PrimaryButton(title: "Sign In") {}
        PrimaryButton(title: "Register") {}
    }
    .padding()
}
