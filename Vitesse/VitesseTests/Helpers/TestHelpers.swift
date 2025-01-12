//
//  TestHelpers.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 09/01/2025.
//

import Foundation
import XCTest
@testable import Vitesse

// MARK: - URL/Request Helpers
func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyURLRequest() -> URLRequest {
    return URLRequest(url: anyURL())
}

// MARK: - Token
func anyToken() -> String {
    return "a token"
}

// MARK: - Data/Error Helpers
func anyData() -> Data {
    return "any data".data(using: .utf8)!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

// MARK: - HTTP Response Helper
func anyHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(
        url: anyURL(),
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
    )!
}

// MARK: - Model Factories
func makeCandidate(
    id: UUID = UUID(),
    firstName: String = "John",
    lastName: String = "Doe",
    email: String = "john@example.com",
    phone: String? = nil,
    linkedinURL: String? = nil,
    note: String? = nil,
    isFavorite: Bool = false
) -> Candidate {
    return Candidate(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        linkedinURL: linkedinURL,
        note: note,
        isFavorite: isFavorite
    )
}

// MARK: - JSON Helpers
func makeJSON(_ value: Any) -> Data {
    return try! JSONSerialization.data(withJSONObject: value)
}

// MARK: - Memory Leak Tracker
extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
