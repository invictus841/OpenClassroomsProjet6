//
//  RegisterViewModelTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 13/01/2025.
//

import XCTest
@testable import Vitesse

final class RegisterViewModelTests: XCTestCase {
    
    func test_init_startsWithEmptyState() {
        let (sut, _, _) = makeSUT()

        XCTAssertTrue(sut.firstName.isEmpty)
        XCTAssertTrue(sut.lastName.isEmpty)
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertTrue(sut.password.isEmpty)
        XCTAssertTrue(sut.confirmPassword.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertNil(sut.successMessage)
        XCTAssertFalse(sut.shouldDismiss)
    }
    
    func test_register_failsWithEmptyFields() async {
        let (sut, client, _) = makeSUT()
        
        await sut.register()
        
        // Should show error without making network request
        XCTAssertEqual(sut.errorMessage, "All fields are required")
        XCTAssertNil(sut.successMessage)
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_register_failsWithPasswordMismatch() async {
        let (sut, client, _) = makeSUT()
        
        // Fill all fields but make passwords different
        sut.firstName = "John"
        sut.lastName = "Doe"
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password456"
        
        await sut.register()
        
        XCTAssertEqual(sut.errorMessage, "Passwords don't match")
        XCTAssertNil(sut.successMessage)
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_register_succeedsAndCallsCallback() async {
        let expectedEmail = "john@example.com"
        var callbackEmail: String?
        
        let (sut, _, _) = makeSUT(
            registerResult: .success((Data(), anyHTTPURLResponse(statusCode: 201))),
            callback: { email in callbackEmail = email }
        )
        
        sut.firstName = "John"
        sut.lastName = "Doe"
        sut.email = expectedEmail
        sut.password = "password123"
        sut.confirmPassword = "password123"
        
        await sut.register()
        
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.successMessage, "Registration successful! You can now login.")
        XCTAssertEqual(callbackEmail, expectedEmail)
        
        // Wait for dismiss delay
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        XCTAssertTrue(sut.shouldDismiss)
    }
    
    func test_register_failsOnServiceError() async {
        let expectedError = anyNSError()
        let (sut, _, _) = makeSUT(registerResult: .failure(expectedError))
        
        sut.firstName = "John"
        sut.lastName = "Doe"
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        
        await sut.register()
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains(expectedError.localizedDescription) ?? false)
        XCTAssertNil(sut.successMessage)
        XCTAssertFalse(sut.shouldDismiss)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        registerResult: Result<(Data, HTTPURLResponse), Error> = .success((Data(), anyHTTPURLResponse(statusCode: 201))),
        callback: @escaping (String) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RegisterViewModel, client: HTTPClientStub, callback: (String) -> Void) {
        let client = HTTPClientStub(result: registerResult)
        let service = RegisterService(client: client)
        let sut = RegisterViewModel(registerService: service, onRegisterSucceed: callback)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client, callback)
    }
}
