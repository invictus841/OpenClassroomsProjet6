//
//  AuthMapper.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

enum LoginMapper {
    struct LoginResponse: Decodable {
        let token: String
        let isAdmin: Bool
    }
    
    static func map(_ data: Data, and response: HTTPURLResponse) throws -> String {
        guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw NetworkError.invalidResponse
        }
        
        return loginResponse.token
    }
}
