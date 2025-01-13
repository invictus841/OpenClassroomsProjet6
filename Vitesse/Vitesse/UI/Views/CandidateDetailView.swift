//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 12/12/2024.
//

import SwiftUI

struct CandidateDetailView: View {
    @ObservedObject var viewModel: CandidateViewModel
    let candidateId: UUID
    
    @State private var isEditing = false
    @State private var editedPhone: String
    @State private var editedEmail: String
    @State private var editedLinkedin: String
    @State private var editedNote: String
    @State private var showAdminRequiredAlert = false
    
    init(candidate: Candidate, viewModel: CandidateViewModel) {
        self.candidateId = candidate.id
        self.viewModel = viewModel
        
        _editedPhone = State(initialValue: candidate.phone ?? "")
        _editedEmail = State(initialValue: candidate.email)
        _editedLinkedin = State(initialValue: candidate.linkedinURL ?? "")
        _editedNote = State(initialValue: candidate.note ?? "")
    }
    
    private var candidate: Candidate {
        if let candidate = viewModel.filteredCandidates.first(where: { $0.id == candidateId }) {
            return candidate
        }
        
        return viewModel.currentCandidate ?? viewModel.candidates.first(where: { $0.id == candidateId })!
    }
    
    private var hasChanges: Bool {
        editedPhone != (candidate.phone ?? "") ||
        editedEmail != candidate.email ||
        editedLinkedin != (candidate.linkedinURL ?? "") ||
        editedNote != (candidate.note ?? "")
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    HStack {
                        Text(candidate.name)
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        FavoriteButton(
                            isFavorite: candidate.isFavorite,
                            isAdmin: viewModel.isAdmin,
                            action: { await viewModel.toggleFavorite(for: candidate) },
                            showAdminRequiredAlert: $showAdminRequiredAlert
                        )
                    }
                    .padding(.bottom, 8)
                    
                    if isEditing {
                        VStack(spacing: 16) {
                            CustomTextField(
                                placeholder: "Enter phone number",
                                label: "Phone",
                                text: $editedPhone,
                                contentType: .telephoneNumber
                            )
                            .keyboardType(.phonePad)
                            
                            CustomTextField(
                                placeholder: "Enter email",
                                label: "Email",
                                text: $editedEmail,
                                contentType: .emailAddress
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            
                            CustomTextField(
                                placeholder: "Enter LinkedIn URL",
                                label: "LinkedIn",
                                text: $editedLinkedin,
                                contentType: .URL
                            )
                            .autocapitalization(.none)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, weight: .medium))
                                
                                TextEditor(text: $editedNote)
                                    .frame(minHeight: 100)
                                    .padding(8)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(.systemGray4), lineWidth: 1)
                                    )
                            }
                            
                            PrimaryButton(title: "Save Changes") {
                                Task {
                                    do {
                                        try await viewModel.updateCandidate(
                                            candidate,
                                            email: editedEmail,
                                            phone: editedPhone,
                                            linkedinURL: editedLinkedin,
                                            note: editedNote
                                        )
                                        isEditing = false
                                    } catch {
                                        // Error is handled in ViewModel
                                    }
                                }
                            }
                            .padding(.top, 16)
                        }
                    } else {
                        VStack(spacing: 20) {
                            InfoRow(label: "Phone", value: candidate.phone ?? "Not provided")
                            InfoRow(label: "Email", value: candidate.email)
                            InfoRow(label: "LinkedIn", value: candidate.linkedinURL ?? "Not provided", isLinkedin: true)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text(candidate.note ?? "No notes available")
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Cancel" : "Edit") {
                        isEditing.toggle()
                    }
                }
            }
            .adminAlert(isPresented: $showAdminRequiredAlert)
            .onAppear {
                viewModel.setCurrentCandidate(candidate)
            }
        }
    }

#Preview {
    CandidatesView(viewModel: CandidateViewModel())
}
