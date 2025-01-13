//
//  CandidateViewModelTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 13/01/2025.
//

import XCTest
@testable import Vitesse

final class CandidateViewModelTests: XCTestCase {
    
    func test_init_startsWithEmptyState() {
        let (sut, _) = makeSUT()
        
        XCTAssertTrue(sut.candidates.isEmpty)
        XCTAssertNil(sut.currentCandidate)
        XCTAssertTrue(sut.searchText.isEmpty)
        XCTAssertFalse(sut.showFavoritesOnly)
        XCTAssertFalse(sut.isAdmin)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchCandidates_deliversCandidatesOnSuccess() async {
        let candidate1 = makeCandidate()
        let candidate2 = makeCandidate(id: UUID(), firstName: "Jane", lastName: "Smith")
        let candidatesArray = [
            makeCandidateJSON(candidate1),
            makeCandidateJSON(candidate2)
        ]
        
        let (sut, _) = makeSUT(result: .success((
            makeJSON(candidatesArray),
            anyHTTPURLResponse()
        )))
        
        await sut.fetchCandidates()
        
        XCTAssertEqual(sut.candidates.count, 2)
        XCTAssertEqual(sut.candidates[0].id, candidate1.id)
        XCTAssertEqual(sut.candidates[1].id, candidate2.id)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchCandidates_deliversErrorOnFailure() async {
        let expectedError = anyNSError()
        let (sut, _) = makeSUT(result: .failure(expectedError))
        
        await sut.fetchCandidates()
        
        XCTAssertTrue(sut.candidates.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
    }
    
    func test_toggleFavorite_updatesLocalStateOnSuccess() async {
        let candidate = makeCandidate(isFavorite: false)
        let updatedCandidate = makeCandidate(id: candidate.id, isFavorite: true)
        
        let (sut, _) = makeSUT(result: .success((
            makeJSON(makeCandidateJSON(updatedCandidate)),
            anyHTTPURLResponse()
        )))
        
        sut.candidates = [candidate]
        await sut.toggleFavorite(for: candidate)
        
        XCTAssertTrue(sut.candidates.first?.isFavorite ?? false)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_updateCandidate_updatesLocalStateOnSuccess() async throws {
        let initialCandidate = makeCandidate(email: "old@email.com", phone: "old")
        let updatedEmail = "new@email.com"
        let updatedPhone = "new"
        
        let expectedCandidate = makeCandidate(
            id: initialCandidate.id,
            email: updatedEmail,
            phone: updatedPhone
        )
        
        let (sut, _) = makeSUT(result: .success((
            makeJSON(makeCandidateJSON(expectedCandidate)),
            anyHTTPURLResponse()
        )))
        
        sut.candidates = [initialCandidate]
        sut.currentCandidate = initialCandidate
        
        try await sut.updateCandidate(
            initialCandidate,
            email: updatedEmail,
            phone: updatedPhone,
            linkedinURL: nil,
            note: nil
        )
        
        XCTAssertEqual(sut.currentCandidate?.email, updatedEmail)
        XCTAssertEqual(sut.currentCandidate?.phone, updatedPhone)
        XCTAssertEqual(sut.candidates.first?.email, updatedEmail)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_deleteCandidates_removesSelectedCandidatesOnSuccess() async {
        let candidate1 = makeCandidate(isSelected: true)
        let candidate2 = makeCandidate(id: UUID(), isSelected: false)
        
        let (sut, _) = makeSUT(result: .success((Data(), anyHTTPURLResponse())))
        sut.candidates = [candidate1, candidate2]
        
        await sut.deleteCandidates()
        
        XCTAssertEqual(sut.candidates.count, 1)
        XCTAssertEqual(sut.candidates.first?.id, candidate2.id)
        XCTAssertFalse(sut.isEditing)
    }
    
    func test_filteredCandidates_filtersBySearchText() {
        let (sut, _) = makeSUT()
        
        let john = makeCandidate(firstName: "John", lastName: "Doe")
        let jane = makeCandidate(id: UUID(), firstName: "Jane", lastName: "Smith")
        sut.candidates = [john, jane]
        
        // Initial state - no filter
        XCTAssertEqual(sut.filteredCandidates.count, 2)
        
        // Filter by "John"
        sut.searchText = "John"
        XCTAssertEqual(sut.filteredCandidates.count, 1)
        XCTAssertEqual(sut.filteredCandidates.first?.id, john.id)
        
        // Filter should be case insensitive
        sut.searchText = "john"
        XCTAssertEqual(sut.filteredCandidates.count, 1)
        XCTAssertEqual(sut.filteredCandidates.first?.id, john.id)
    }

    func test_filteredCandidates_filtersByFavorites() {
        let (sut, _) = makeSUT()
        
        let favorite = makeCandidate(isFavorite: true)
        let nonFavorite = makeCandidate(id: UUID(), isFavorite: false)
        sut.candidates = [favorite, nonFavorite]
        
        // Initial state - no favorite filter
        XCTAssertEqual(sut.filteredCandidates.count, 2)
        
        // Show only favorites
        sut.showFavoritesOnly = true
        XCTAssertEqual(sut.filteredCandidates.count, 1)
        XCTAssertEqual(sut.filteredCandidates.first?.id, favorite.id)
    }

    func test_selectedCandidatesCount_returnsCorrectCount() {
        let (sut, _) = makeSUT()
        
        let selected1 = makeCandidate(isSelected: true)
        let selected2 = makeCandidate(id: UUID(), isSelected: true)
        let notSelected = makeCandidate(id: UUID(), isSelected: false)
        
        sut.candidates = [selected1, selected2, notSelected]
        
        XCTAssertEqual(sut.selectedCandidatesCount, 2)
    }

    func test_toggleFavorite_setsErrorMessageOnFailure() async {
        let candidate = makeCandidate()
        let expectedError = anyNSError()
        let (sut, _) = makeSUT(result: .failure(expectedError))
        
        sut.candidates = [candidate]
        await sut.toggleFavorite(for: candidate)
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.candidates.first?.isFavorite ?? true)
    }

    func test_toggleFavorite_updatesCurrentCandidateWhenMatched() async {
        let candidate = makeCandidate(isFavorite: false)
        let updatedCandidate = makeCandidate(id: candidate.id, isFavorite: true)
        
        let (sut, _) = makeSUT(result: .success((
            makeJSON(makeCandidateJSON(updatedCandidate)),
            anyHTTPURLResponse()
        )))
        
        sut.candidates = [candidate]
        sut.currentCandidate = candidate
        
        await sut.toggleFavorite(for: candidate)
        
        XCTAssertTrue(sut.currentCandidate?.isFavorite ?? false)
    }

    @MainActor
    func test_setCurrentCandidate_updatesCurrentCandidate() {
        let (sut, _) = makeSUT()
        let candidate = makeCandidate()
        
        sut.setCurrentCandidate(candidate)
        
        XCTAssertEqual(sut.currentCandidate?.id, candidate.id)
    }

    func test_toggleSelection_togglesCandidateSelection() {
        let (sut, _) = makeSUT()
        let candidate = makeCandidate(isSelected: false)
        
        sut.candidates = [candidate]
        
        // Toggle selection on
        sut.toggleSelection(for: candidate.id)
        XCTAssertTrue(sut.candidates.first?.isSelected ?? false)
        
        // Toggle selection off
        sut.toggleSelection(for: candidate.id)
        XCTAssertFalse(sut.candidates.first?.isSelected ?? false)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        result: Result<(Data, HTTPURLResponse), Error> = .success((Data(), anyHTTPURLResponse())),
        isAdmin: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CandidateViewModel, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let service = CandidateService(client: client)
        let sut = CandidateViewModel(candidateService: service, isAdmin: isAdmin)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
}
