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
    
    func login(with request: URLRequest) async throws -> (token: String, isAdmin: Bool) {
        let (data, response) = try await client.request(from: request)
        return try LoginMapper.map(data, and: response)
    }
}
