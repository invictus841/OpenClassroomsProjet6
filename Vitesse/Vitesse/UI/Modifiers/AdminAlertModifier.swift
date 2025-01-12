//
//  AdminAlertModifier.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 06/01/2025.
//

import SwiftUI

struct AdminAlertModifier: ViewModifier {
    @Binding var showAlert: Bool
    
    func body(content: Content) -> some View {
        content
            .alert("Admin Access Required", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You need administrator privileges to modify favorite status.")
            }
    }
}

extension View {
    func adminAlert(isPresented: Binding<Bool>) -> some View {
        modifier(AdminAlertModifier(showAlert: isPresented))
    }
}

#Preview {
    Text("Test View")
        .modifier(AdminAlertModifier(showAlert: .constant(true)))
}
