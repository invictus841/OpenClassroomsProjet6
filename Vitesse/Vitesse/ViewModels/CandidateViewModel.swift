//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 01/01/2025.
//

import Foundation

final class CandidateViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var currentCandidate: Candidate?
    @Published var searchText = ""
    @Published var showFavoritesOnly = false
    @Published var isEditing = false
    @Published var errorMessage: String?
    @Published var isAdmin: Bool = false
    
    private let candidateService: CandidateService
    
    init(candidateService: CandidateService = CandidateService(), isAdmin: Bool = false) {
        self.candidateService = candidateService
        self.isAdmin = isAdmin
    }
    
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
    
    @MainActor
    func fetchCandidates() async {
        print("Attempting to fetch candidates...")
        do {
            let fetchedCandidates = try await candidateService.fetchCandidates()
            print("Fetched candidates details:")
            for candidate in fetchedCandidates {
                print("ID: \(candidate.id), Name: \(candidate.name), IsFavorite: \(candidate.isFavorite)")
            }
            candidates = fetchedCandidates
        } catch {
            print("Error fetching candidates: \(error)")
            errorMessage = "Failed to load candidates: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func toggleFavorite(for candidate: Candidate) async {
        print("=== Starting Toggle Favorite ===")
        print("Candidate before toggle - ID: \(candidate.id), Name: \(candidate.name), IsFavorite: \(candidate.isFavorite)")
        
        do {
            let updatedCandidate = try await candidateService.toggleFavorite(for: candidate.id)
            print("Toggle API call successful")
            print("Updated candidate - ID: \(updatedCandidate.id), IsFavorite: \(updatedCandidate.isFavorite)")
            
            // Update in candidates array
            if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
                candidates[index] = updatedCandidate
                print("Successfully updated candidate in local array at index \(index)")
            }
            
            // Update current candidate if it's the same one
            if currentCandidate?.id == candidate.id {
                currentCandidate = updatedCandidate
                print("Updated current candidate")
            }
            
        } catch {
            print("=== Toggle Failed ===")
            print("Error type: \(type(of: error))")
            print("Error description: \(error.localizedDescription)")
            errorMessage = "Failed to update favorite status: \(error.localizedDescription)"
        }
        print("=== End Toggle Favorite ===")
    }
    
    @MainActor
    func deleteCandidates() async {
        let candidatesToDelete = candidates.filter { $0.isSelected }
        for candidate in candidatesToDelete {
            do {
                try await candidateService.deleteCandidate(candidate.id)
                if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
                    candidates.remove(at: index)
                }
            } catch {
                errorMessage = "Failed to delete candidate: \(error.localizedDescription)"
            }
        }
        isEditing = false
    }
    
    @MainActor
    func updateCandidate(_ candidate: Candidate,
                         email: String,
                         phone: String,
                         linkedinURL: String?,
                         note: String?) async throws {
        let updates: [String: Any] = [
            "email": email,
            "phone": phone,
            "linkedinURL": linkedinURL as Any,
            "note": note as Any,
            "firstName": candidate.firstName,
            "lastName": candidate.lastName
        ]
        
        do {
            let updatedCandidate = try await candidateService.updateCandidate(candidate.id, with: updates)
            
            // Mettre à jour le candidat actuel
            currentCandidate = updatedCandidate
            
            // Mettre à jour la liste des candidats
            candidates = candidates.map { existingCandidate in
                if existingCandidate.id == updatedCandidate.id {
                    return updatedCandidate
                }
                return existingCandidate
            }
        } catch {
            errorMessage = "Failed to update candidate: \(error.localizedDescription)"
            throw error
        }
    }
    
    @MainActor
    func setCurrentCandidate(_ candidate: Candidate) {
        self.currentCandidate = candidate
    }
    
    func toggleSelection(for candidateId: UUID) {
        if let index = candidates.firstIndex(where: { $0.id == candidateId }) {
            candidates[index].isSelected.toggle()
        }
    }
}
