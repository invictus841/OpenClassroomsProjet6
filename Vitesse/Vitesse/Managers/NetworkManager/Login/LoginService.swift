//
//  Authenticator.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

final class LoginService {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func requestToken(from request: URLRequest) async throws -> String {
        let (data, response) = try await client.request(from: request)
        let token = try LoginMapper.map(data, and: response)
        
        return token
    }
}
