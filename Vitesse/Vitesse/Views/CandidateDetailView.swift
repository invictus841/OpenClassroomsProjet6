//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 12/12/2024.
//

import SwiftUI

struct CandidateDetailView: View {
    @State var candidate: Candidate
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 40) {
                HStack {
                    Text("Phone:")
                    Text(candidate.phone)
                }
                
                HStack {
                    Text("Email:")
                    Text(candidate.email)
                }
                
                HStack {
                    Text("LinkedIn:")
                    Text(candidate.linkedin)
                }
                
                VStack {
                    Text("Note:")
                    Text(candidate.note)
                }
            }
            .padding(40)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(candidate.name)
        }
    }
    
    
}

#Preview {
    CandidateDetailView(candidate: Candidate(name: "Test", isFavorite: false, isSelected: false, phone: "012345", email: "test@test.com", linkedin: "test.test", note: "Test"))
}
