//
//  InfoRow.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 09/01/2025.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String
    let isLinkedin: Bool
    
    init(label: String, value: String, isLinkedin: Bool = false) {
        self.label = label
        self.value = value
        self.isLinkedin = isLinkedin
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            if isLinkedin && value != "Not provided" {
                Link(value, destination: URL(string: value) ?? URL(string: "https://www.linkedin.com")!)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .foregroundColor(.blue)
            } else {
                Text(value)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    InfoRow(label: "Test", value: "Test")
}
