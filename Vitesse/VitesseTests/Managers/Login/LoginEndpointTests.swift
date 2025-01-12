//
//  LoginEndpointTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 12/01/2025.
//

import XCTest
@testable import Vitesse

final class LoginEndpointTests: XCTestCase {
    
    func test_loginRequest_createsCorrectURLRequestWithEmailAndPassword() throws {
        let email = "test@email.com"
        let password = "password123"
        
        let request = try LoginEndpoint.loginRequest(email: email, password: password)
        
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/user/auth")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        
        let receivedJSON = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: String]
        XCTAssertEqual(receivedJSON?["email"], email)
        XCTAssertEqual(receivedJSON?["password"], password)
    }
}
