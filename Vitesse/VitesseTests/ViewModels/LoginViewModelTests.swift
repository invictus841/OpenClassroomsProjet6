//
//  LoginViewModelTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 12/01/2025.
//

import XCTest
@testable import Vitesse

final class LoginViewModelTests: XCTestCase {
    
    func test_init_startsWithEmptyState() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertTrue(sut.password.isEmpty)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_login_succeedsWithTokenStorageAndCallback() async {
        let expectedToken = anyToken()
        let isAdmin = true
        var callbackCalled = false
        
        let (sut, _, tokenStore) = makeSUT(
            loginResult: .success((
                makeJSON(["token": expectedToken, "isAdmin": isAdmin]),
                anyHTTPURLResponse()
            )),
            callback: { receivedIsAdmin in
                callbackCalled = true
                XCTAssertTrue(receivedIsAdmin)
            }
        )
        
        sut.email = "email@example.com"
        sut.password = "password"
        
        await sut.login()
        
        XCTAssertTrue(callbackCalled)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(tokenStore.messages, [.insert(expectedToken.data(using: .utf8)!)])
    }
    
    func test_login_failsWithEmptyCredentials() async {
        let (sut, client, _) = makeSUT()
        
        await sut.login()
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_login_failsOnLoginServiceError() async {
        let expectedError = anyNSError()
        var callbackCalled = false
        
        let (sut, _, _) = makeSUT(
            loginResult: .failure(expectedError),
            callback: { _ in callbackCalled = true }
        )
        
        sut.email = "email@example.com"
        sut.password = "password"
        
        await sut.login()
        
        XCTAssertFalse(callbackCalled)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains(expectedError.localizedDescription) ?? false)
    }
    
    func test_login_failsOnTokenStorageError() async {
        let expectedToken = anyToken()
        let isAdmin = true
        var callbackCalled = false
        let expectedError = anyNSError()
        
        let (sut, _, tokenStore) = makeSUT(
            loginResult: .success((
                makeJSON(["token": expectedToken, "isAdmin": isAdmin]),
                anyHTTPURLResponse()
            )),
            callback: { _ in callbackCalled = true }
        )
        
        sut.email = "email@example.com"
        sut.password = "password"
        
        tokenStore.simulateInsertionFailure(expectedError)
        
        await sut.login()
        
        XCTAssertFalse(callbackCalled)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(tokenStore.messages, [.insert(expectedToken.data(using: .utf8)!)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        loginResult: Result<(Data, HTTPURLResponse), Error> = .success((Data(), anyHTTPURLResponse())),
        callback: @escaping (Bool) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LoginViewModel, client: HTTPClientStub, tokenStore: TokenStoreSpy) {
        let client = HTTPClientStub(result: loginResult)
        let service = LoginService(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = LoginViewModel(loginService: service, tokenStore: tokenStore, callback)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(tokenStore, file: file, line: line)
        
        return (sut, client, tokenStore)
    }
}
