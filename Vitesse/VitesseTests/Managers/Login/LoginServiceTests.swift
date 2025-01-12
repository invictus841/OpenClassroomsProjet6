//
//  LoginServiceTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 12/01/2025.
//

import XCTest
@testable import Vitesse

final class LoginServiceTests: XCTestCase {
    
    func test_init_doesNotMakeRequest() {
        let client = HTTPClientStub(result: .success((anyData(), anyHTTPURLResponse())))
        let _ = LoginService(client: client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_login_deliversErrorOnClientError() async {
        let expectedError = anyNSError()
        let (sut, _) = makeSUT(result: .failure(expectedError))
        
        do {
            _ = try await sut.login(with: anyURLRequest())
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_login_deliversTokenAndIsAdminOnSuccessfulResponse() async throws {
        let token = anyToken()
        let isAdmin = true
        let json: [String: Any] = [
            "token": token,
            "isAdmin": isAdmin
        ]
        let (sut, _) = makeSUT(result: .success((makeJSON(json), anyHTTPURLResponse())))
        
        let result = try await sut.login(with: anyURLRequest())
        
        XCTAssertEqual(result.token, token)
        XCTAssertEqual(result.isAdmin, isAdmin)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        result: Result<(Data, HTTPURLResponse), Error> = .success((Data(), anyHTTPURLResponse())),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LoginService, client: HTTPClientStub) {
        
        let client = HTTPClientStub(result: result)
        let sut = LoginService(client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
}
