//
//  CandidatesEndpoint.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 01/01/2025.
//

import Foundation

enum CandidatesEndpoint {
    static func listRequest(token: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func deleteRequest(id: UUID, token: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate/\(id)")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func toggleFavoriteRequest(id: UUID, token: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate/\(id.uuidString)/favorite")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func updateRequest(id: UUID, token: String, updatedCandidate: [String: Any]) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate/\(id)")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: updatedCandidate)
        return request
    }
}
