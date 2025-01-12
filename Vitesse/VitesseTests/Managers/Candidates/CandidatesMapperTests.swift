//
//  CandidatesMapperTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 10/01/2025.
//

import XCTest
@testable import Vitesse

final class CandidatesMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJSON([
            "id": UUID().uuidString,
            "firstName": "John",
            "lastName": "Doe",
            "email": "john@example.com",
            "isFavorite": false
        ])
        
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try CandidatesMapper.map(json, and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOnInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try CandidatesMapper.map(invalidJSON, and: anyHTTPURLResponse())
        )
    }
    
    func test_map_deliversCandidatesOnValidJSONResponse() throws {
        let candidate1 = makeCandidate()
        let candidate2 = makeCandidate()
        
        let json = makeJSON([
            [
                "id": candidate1.id.uuidString,
                "firstName": candidate1.firstName,
                "lastName": candidate1.lastName,
                "email": candidate1.email,
                "isFavorite": candidate1.isFavorite
            ],
            [
                "id": candidate2.id.uuidString,
                "firstName": candidate2.firstName,
                "lastName": candidate2.lastName,
                "email": candidate2.email,
                "isFavorite": candidate2.isFavorite
            ]
        ])
        
        let result = try CandidatesMapper.map(json, and: anyHTTPURLResponse())
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, candidate1.id)
        XCTAssertEqual(result[1].id, candidate2.id)
    }
}
