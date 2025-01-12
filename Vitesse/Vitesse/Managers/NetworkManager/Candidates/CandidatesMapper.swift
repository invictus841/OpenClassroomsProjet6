//
//  CandidatesMapper.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 01/01/2025.
//

import Foundation

enum CandidatesMapper {
    static func map(_ data: Data, and response: HTTPURLResponse) throws -> [Candidate] {
        print("Response status code: \(response.statusCode)")
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Raw response data: \(responseString)")
        }
        
        do {
            let candidates = try JSONDecoder().decode([Candidate].self, from: data)
            print("Successfully decoded \(candidates.count) candidates")
            return candidates
        } catch let decodingError {
            print("Decoding error details: \(decodingError)")
            throw NetworkError.invalidResponse
        }
    }
    
    static func mapSingle(_ data: Data, and response: HTTPURLResponse) throws -> Candidate {
        guard response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let candidate = try JSONDecoder().decode(Candidate.self, from: data)
            return candidate
        } catch {
            print("Decoding error details: \(error)")
            throw NetworkError.invalidResponse
        }
    }
}
