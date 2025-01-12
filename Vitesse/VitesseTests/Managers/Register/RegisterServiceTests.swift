//
//  RegisterServiceTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 12/01/2025.
//

import XCTest
@testable import Vitesse

final class RegisterServiceTests: XCTestCase {
    
    func test_init_doesNotMakeRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_register_failsOnClientError() async {
        let expectedError = anyNSError()
        let (sut, _) = makeSUT(result: .failure(expectedError))
        
        do {
            try await sut.register(firstName: "John", lastName: "Doe", email: "john@example.com", password: "123")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_register_succeedsOn201Response() async throws {
        let (sut, _) = makeSUT(result: .success((Data(), anyHTTPURLResponse(statusCode: 201))))
        
        try await sut.register(firstName: "John", lastName: "Doe", email: "john@example.com", password: "123")
    }
    
    func test_register_failsOnNon201Response() async {
        let (sut, _) = makeSUT(result: .success((Data(), anyHTTPURLResponse(statusCode: 400))))
        
        do {
            try await sut.register(firstName: "John", lastName: "Doe", email: "john@example.com", password: "123")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        result: Result<(Data, HTTPURLResponse), Error> = .success((Data(), anyHTTPURLResponse())),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RegisterService, client: HTTPClientStub) {
        
        let client = HTTPClientStub(result: result)
        let sut = RegisterService(client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
}
