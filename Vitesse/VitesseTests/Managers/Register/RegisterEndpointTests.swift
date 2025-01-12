//
//  RegisterEndpointTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 12/01/2025.
//

import XCTest
@testable import Vitesse

final class RegisterEndpointTests: XCTestCase {
    
    func test_request_createsCorrectURLRequestWithUserData() throws {
        let firstName = "John"
        let lastName = "Doe"
        let email = "john@example.com"
        let password = "password123"
        
        let request = try RegisterEndpoint.request(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )
        
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/user/register")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        
        let receivedJSON = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: String]
        XCTAssertEqual(receivedJSON?["firstName"], firstName)
        XCTAssertEqual(receivedJSON?["lastName"], lastName)
        XCTAssertEqual(receivedJSON?["email"], email)
        XCTAssertEqual(receivedJSON?["password"], password)
    }
}
