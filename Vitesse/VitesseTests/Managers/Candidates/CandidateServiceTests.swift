//
//  CandidateServiceTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 10/01/2025.
//

import XCTest
@testable import Vitesse

final class CandidateServiceTests: XCTestCase {
    
    func test_init_doesNotRequestFromURL() {
        let (_, client, _) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_fetchCandidates_failsOnTokenStoreError() async {
        let (sut, _, tokenStore) = makeSUT()
        let expectedError = anyNSError()
        
        tokenStore.simulateRetrievalFailure(expectedError)
        
        do {
            _ = try await sut.fetchCandidates()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_fetchCandidates_failsOnRequestError() async {
        let expectedError = anyNSError()
        let (sut, _ , tokenStore) = makeSUT(result: .failure(expectedError))
        
        tokenStore.simulateRetrievalSuccess(anyToken().data(using: .utf8)!)
        
        do {
            _ = try await sut.fetchCandidates()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_fetchCandidates_deliversCandidatesOnSuccessfulResponse() async throws {
        let candidate1 = makeCandidate()
        let candidate2 = makeCandidate(id: UUID(), firstName: "Jane", lastName: "Smith", email: "jane@example.com")
        
        let candidatesArray = [
            makeCandidateJSON(candidate1),
            makeCandidateJSON(candidate2)
        ]
        
        let response = anyHTTPURLResponse(statusCode: 200)
        
        let (sut, _, tokenStore) = makeSUT(result: .success((makeJSON(candidatesArray), response)))
        
        tokenStore.simulateRetrievalSuccess(anyToken().data(using: .utf8)!)
        
        let candidates = try await sut.fetchCandidates()
        
        XCTAssertEqual(candidates.count, 2)
        XCTAssertEqual(candidates[0].id, candidate1.id)
        XCTAssertEqual(candidates[1].id, candidate2.id)
    }
    
    func test_deleteCandidate_failsOnTokenStoreError() async {
        let (sut, _, tokenStore) = makeSUT()
        let expectedError = anyNSError()
        let id = UUID()
        
        tokenStore.simulateRetrievalFailure(expectedError)
        
        do {
            try await sut.deleteCandidate(id)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_deleteCandidate_succeedsOnValidResponse() async throws {
        let response = anyHTTPURLResponse(statusCode: 200)
        let (sut, _, tokenStore) = makeSUT(result: .success((anyData(), response)))
        let id = UUID()
        
        tokenStore.simulateRetrievalSuccess(anyToken().data(using: .utf8)!)
    
        try await sut.deleteCandidate(id)
    }
    
    func test_updateCandidate_failsOnTokenStoreError() async {
        let (sut, _, tokenStore) = makeSUT()
        let expectedError = anyNSError()
        let id = UUID()
        let updates = ["firstName": "John"]
        
        tokenStore.simulateRetrievalFailure(expectedError)
        
        do {
            _ = try await sut.updateCandidate(id, with: updates)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_updateCandidate_deliversUpdatedCandidateOnSuccess() async throws {
        let id = UUID()
        let updatedCandidate = makeCandidate(
            id: id,
            firstName: "John",
            lastName: "Updated",
            email: "john@updated.com"
        )
        let response = anyHTTPURLResponse(statusCode: 200)
        let (sut, _, tokenStore) = makeSUT(result: .success((makeJSON(makeCandidateJSON(updatedCandidate)), response)))
        tokenStore.simulateRetrievalSuccess(anyToken().data(using: .utf8)!)
        
        let result = try await sut.updateCandidate(id, with: makeCandidateJSON(updatedCandidate))
        
        XCTAssertEqual(result.id, updatedCandidate.id)
        XCTAssertEqual(result.firstName, updatedCandidate.firstName)
        XCTAssertEqual(result.lastName, updatedCandidate.lastName)
        XCTAssertEqual(result.email, updatedCandidate.email)
    }
    
    func test_toggleFavorite_failsOnTokenStoreError() async {
        let (sut, _, tokenStore) = makeSUT()
        let expectedError = anyNSError()
        let id = UUID()
        
        tokenStore.simulateRetrievalFailure(expectedError)
        
        do {
            _ = try await sut.toggleFavorite(for: id)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_toggleFavorite_deliversUpdatedCandidateOnSuccess() async throws {
        let response = anyHTTPURLResponse(statusCode: 200)
        let id = UUID()
        let updatedCandidate = makeCandidate(
            id: id,
            firstName: "John",
            lastName: "Doe",
            email: "john@example.com",
            isFavorite: true
        )
        let (sut, _, tokenStore) = makeSUT(result: .success((makeJSON(makeCandidateJSON(updatedCandidate)), response)))
        
        tokenStore.simulateRetrievalSuccess(anyToken().data(using: .utf8)!)

        
        let result = try await sut.toggleFavorite(for: id)
        
        XCTAssertEqual(result.id, updatedCandidate.id)
        XCTAssertEqual(result.isFavorite, updatedCandidate.isFavorite)
    }
    
    func test_toggleFavorite_failsOnNon200Response() async {
        let response = HTTPURLResponse(url: anyURL(), statusCode: 404, httpVersion: nil, headerFields: nil)!
        let (sut, _, tokenStore) = makeSUT(result: .success((Data(), response)))
        let id = UUID()
        
        tokenStore.simulateRetrievalSuccess(anyToken().data(using: .utf8)!)
        
        do {
            _ = try await sut.toggleFavorite(for: id)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? NetworkError, .serverError("Candidate not found"))
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
    result: Result<(Data, HTTPURLResponse), Error> = .success((Data(), anyHTTPURLResponse())),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CandidateService, client: HTTPClientStub, tokenStore: TokenStoreSpy) {
        
        let client = HTTPClientStub(result: result)
        let tokenStore = TokenStoreSpy()
        let sut = CandidateService(client: client, tokenStore: tokenStore)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(tokenStore, file: file, line: line)
        
        return (sut, client, tokenStore)
    }
}
