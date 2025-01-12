//
//  RegisterMapperTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 12/01/2025.
//

import XCTest
@testable import Vitesse

final class RegisterMapperTests: XCTestCase {
    
    func test_map_succeedsOn201Response() throws {
        let response = anyHTTPURLResponse(statusCode: 201)
        
        XCTAssertNoThrow(try RegisterMapper.map(anyData(), and: response))
    }
    
    func test_map_throwsErrorOnNon201Response() {
        let sampleCodes = [200, 400, 401, 403, 404, 500]
        
        for code in sampleCodes {
            let response = anyHTTPURLResponse(statusCode: code)
            
            do {
                try RegisterMapper.map(anyData(), and: response)
                XCTFail("Expected error for status code \(code)")
            } catch {
                XCTAssertEqual(error as? NetworkError, .invalidResponse)
            }
        }
    }
}
