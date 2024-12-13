//
//  CandidatesView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 12/12/2024.
//

import SwiftUI

struct Candidate: Identifiable {
    let id = UUID()
    let name: String
    var isFavorite: Bool
    var isSelected: Bool = false

    var phone: String
    var email: String
    var linkedin: String
    var note: String
}

struct CandidatesView: View {
    @State private var candidates = [
        Candidate(
            name: "Jean Pierre P.",
            isFavorite: true,
            isSelected: false,
            phone: "0645781234",
            email: "jean.pierre.p@gmail.com",
            linkedin: "jean.pierre.p",
            note: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore."
        ),
        Candidate(
            name: "Jean Michel P.",
            isFavorite: false,
            isSelected: false,
            phone: "0645782345",
            email: "jean.michel.p@gmail.com",
            linkedin: "jean.michel.p",
            note: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo."
        ),
        Candidate(
            name: "Jean Pierre A.",
            isFavorite: true,
            isSelected: false,
            phone: "0645783456",
            email: "jean.pierre.a@gmail.com",
            linkedin: "jean.pierre.a",
            note: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla."
        ),
        Candidate(
            name: "Jean Michel Z.",
            isFavorite: false,
            isSelected: false,
            phone: "0645784567",
            email: "jean.michel.z@gmail.com",
            linkedin: "jean.michel.z",
            note: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim."
        ),
        Candidate(
            name: "Jean Pierre B.",
            isFavorite: true,
            isSelected: false,
            phone: "0645785678",
            email: "jean.pierre.b@gmail.com",
            linkedin: "jean.pierre.b",
            note: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum."
        ),
        Candidate(
            name: "Jean Michel M.",
            isFavorite: false,
            isSelected: false,
            phone: "0645786789",
            email: "jean.michel.m@gmail.com",
            linkedin: "jean.michel.m",
            note: "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod."
        )
    ]
    
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            let matchesSearch = searchText.isEmpty ||
            candidate.name.lowercased().contains(searchText.lowercased())
            let matchesFavorite = !showFavoritesOnly || candidate.isFavorite
            return matchesSearch && matchesFavorite
        }
    }
    
    var selectedCandidatesCount: Int {
        candidates.filter { $0.isSelected }.count
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(isEditing ? "Cancel" : "Edit") {
                        if isEditing {
                            candidates = candidates.map { candidate in
                                var newCandidate = candidate
                                newCandidate.isSelected = false
                                return newCandidate
                            }
                        }
                        isEditing.toggle()
                    }
                    
                    Spacer()
                    
                    Text("Candidats")
                        .font(.headline)
                    
                    Spacer()
                    
                    if isEditing {
                        Button("Delete") {
                            if selectedCandidatesCount > 0 {
                                showDeleteAlert = true
                            }
                        }
                        .foregroundColor(.red)
                    } else {
                        Button {
                            showFavoritesOnly.toggle()
                        } label: {
                            Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                        }
                    }
                }
                .padding()
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    ForEach(filteredCandidates) { candidate in
                        if isEditing {
                            HStack {
                                Image(systemName: candidate.isSelected ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(candidate.isSelected ? .blue : .gray)
                                    .font(.system(size: 20))
                                
                                Text(candidate.name)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20))
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
                                    candidates[index].isSelected.toggle()
                                }
                            }
                        } else {
                            NavigationLink(destination: CandidateDetailView(candidate: candidate)) {
                                HStack {
                                    Text(candidate.name)
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                    
                                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 20))
                                        .onTapGesture {
                                            if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
                                                candidates[index].isFavorite.toggle()
                                            }
                                        }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Selected Candidates"),
                    message: Text("Are you sure you want to delete \(selectedCandidatesCount) candidate(s)?"),
                    primaryButton: .destructive(Text("Delete")) {
                        candidates.removeAll(where: { $0.isSelected })
                        isEditing = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    CandidatesView()
}
