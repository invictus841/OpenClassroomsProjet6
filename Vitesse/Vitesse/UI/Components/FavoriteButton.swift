//
//  FavoriteButton.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 06/01/2025.
//

import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let isAdmin: Bool
    let action: () async -> Void
    @Binding var showAdminRequiredAlert: Bool
    
    var body: some View {
        Image(systemName: isFavorite ? "star.fill" : "star")
            .foregroundColor(.yellow)
            .font(.system(size: 20))
            .opacity(isAdmin ? 1 : 0.5)
            .onTapGesture {
                if isAdmin {
                    Task {
                        await action()
                    }
                } else {
                    showAdminRequiredAlert = true
                }
            }
    }
}

#Preview {
    FavoriteButton(isFavorite: true, isAdmin: true, action: {}, showAdminRequiredAlert: .constant(false))
}
