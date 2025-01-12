//
//  CandidatesView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 12/12/2024.
//

import SwiftUI

struct CandidatesView: View {
    @ObservedObject var viewModel: CandidateViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
            VStack {
                HStack {
                    Button(viewModel.isEditing ? "Cancel" : "Edit") {
                        viewModel.isEditing.toggle()
                    }
                    
                    Spacer()
                    
                    Text("Candidats")
                        .font(.headline)
                    
                    Spacer()
                    
                    if viewModel.isEditing {
                        Button("Delete") {
                            if viewModel.selectedCandidatesCount > 0 {
                                showDeleteAlert = true
                            }
                        }
                        .foregroundColor(.red)
                    } else {
                        Button {
                            viewModel.showFavoritesOnly.toggle()
                        } label: {
                            Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                        }
                    }
                }
                .padding()
                
                TextField("Search", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    ForEach(viewModel.filteredCandidates) { candidate in
                        if viewModel.isEditing {
                            HStack {
                                Image(systemName: candidate.isSelected ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(candidate.isSelected ? .blue : .gray)
                                    .font(.system(size: 20))
                                
                                Text(candidate.name)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.toggleSelection(for: candidate.id)
                            }
                        } else {
                            NavigationLink(destination: CandidateDetailView(
                                candidate: candidate,
                                viewModel: viewModel
                            )) {
                                HStack {
                                    Text(candidate.name)
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                    
                                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Selected Candidates"),
                    message: Text("Are you sure you want to delete \(viewModel.selectedCandidatesCount) candidate(s)?"),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            await viewModel.deleteCandidates()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .task {
                await viewModel.fetchCandidates()
            }
        }
    }

#Preview {
    NavigationStack {
        CandidatesView(viewModel: CandidateViewModel(isAdmin: true))
    }
}
