//
//  CandidatesEndpointTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 10/01/2025.
//

import XCTest
@testable import Vitesse

final class CandidatesEndpointTests: XCTestCase {
    
    func test_listRequest_createsCorrectURLRequestWithToken() throws {
        let token = anyToken()
        let request = try CandidatesEndpoint.listRequest(token: token)
        
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/candidate")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
    }
    
    func test_deleteRequest_createsCorrectURLRequestWithTokenAndID() throws {
        let token = anyToken()
        let id = UUID()
        let request = try CandidatesEndpoint.deleteRequest(id: id, token: token)
        
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/candidate/\(id)")
        XCTAssertEqual(request.httpMethod, "DELETE")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
    }
    
    func test_toggleFavoriteRequest_createsCorrectURLRequestWithTokenAndID() throws {
        let token = anyToken()
        let id = UUID()
        let request = try CandidatesEndpoint.toggleFavoriteRequest(id: id, token: token)
        
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/candidate/\(id.uuidString)/favorite")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
    }
    
    func test_updateRequest_createsCorrectURLRequestWithTokenIDAndBody() throws {
        let token = anyToken()
        let id = UUID()
        let updates = ["name": "John Doe"]
        
        let request = try CandidatesEndpoint.updateRequest(id: id, token: token, updatedCandidate: updates)
        
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/candidate/\(id)")
        XCTAssertEqual(request.httpMethod, "PUT")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        
        let receivedJSON = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        XCTAssertEqual(receivedJSON?["name"] as? String, "John Doe")
    }
}
