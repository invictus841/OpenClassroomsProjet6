//
//  CandidatesService.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 01/01/2025.
//

import Foundation

final class CandidateService {
    private let client: HTTPClient
    private let tokenStore: TokenStore
    
    init(client: HTTPClient = URLSessionHTTPClient(),
         tokenStore: TokenStore = KeychainStore()) {
        self.client = client
        self.tokenStore = tokenStore
    }
    
    func fetchCandidates() async throws -> [Candidate] {
        let token = String(data: try tokenStore.retrieve(), encoding: .utf8) ?? ""
        let request = try CandidatesEndpoint.listRequest(token: token)
        let (data, response) = try await client.request(from: request)
        
        // Add these debug prints
        print("Response Status: \(response)")
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON: \(jsonString)")
        }
        
        return try CandidatesMapper.map(data, and: response )
    }
    
    func deleteCandidate(_ id: UUID) async throws {
        let token = String(data: try tokenStore.retrieve(), encoding: .utf8) ?? ""
        let request = try CandidatesEndpoint.deleteRequest(id: id, token: token)
        let (_, response) = try await client.request(from: request)
        
        guard response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
    }
    
    func updateCandidate(_ id: UUID, with updates: [String: Any]) async throws -> Candidate {
        print("=== Service: Updating Candidate ===")
        print("ID: \(id)")
        print("Updates: \(updates)")
        
        let token = String(data: try tokenStore.retrieve(), encoding: .utf8) ?? ""
        let request = try CandidatesEndpoint.updateRequest(id: id, token: token, updatedCandidate: updates)
        let (data, response) = try await client.request(from: request)
        
        print("Response status: \(response.statusCode)")
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response data: \(jsonString)")
        }
        
        return try CandidatesMapper.mapSingle(data, and: response)
    }
    
    func toggleFavorite(for candidateId: UUID) async throws -> Candidate {
        let token = String(data: try tokenStore.retrieve(), encoding: .utf8) ?? ""
        let request = try CandidatesEndpoint.toggleFavoriteRequest(id: candidateId, token: token)
        let (data, response) = try await client.request(from: request)
        
        print("Toggle favorite response status: \(response.statusCode)")
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Toggle favorite raw response: \(jsonString)")
        }

        // Handle different status codes
        switch response.statusCode {
        case 200:
            guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
                throw NetworkError.invalidData
            }
            return candidate
        case 404:
            throw NetworkError.serverError("Candidate not found")
        default:
            throw NetworkError.serverError("Unexpected status code: \(response.statusCode)")
        }
    }
}
