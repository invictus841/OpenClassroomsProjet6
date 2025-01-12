//
//  LoginMapperTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 12/01/2025.
//

import XCTest
@testable import Vitesse

final class LoginMapperTests: XCTestCase {

    func test_map_deliversTokenAndIsAdminOnValidJSON() throws {
        let token = anyToken()
        let isAdmin = true
        let json: [String: Any] = [
            "token": token,
            "isAdmin": isAdmin
        ]
        
        let result = try LoginMapper.map(makeJSON(json), and: anyHTTPURLResponse())
        
        XCTAssertEqual(result.token, token)
        XCTAssertEqual(result.isAdmin, isAdmin)
    }
    
    func test_map_throwsErrorOnNon200Response() {
        let json: [String: Any] = ["token": anyToken(), "isAdmin": true]
        let samples = [199, 201, 300, 400, 500]
        
        for code in samples {
            do {
                _ = try LoginMapper.map(makeJSON(json), and: anyHTTPURLResponse(statusCode: code))
                XCTFail("Expected error for status code \(code)")
            } catch {
                XCTAssertEqual(error as? NetworkError, .invalidResponse)
            }
        }
    }

    func test_map_throwsErrorOnInvalidJSON() {
        do {
            _ = try LoginMapper.map(anyData(), and: anyHTTPURLResponse())
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
}
