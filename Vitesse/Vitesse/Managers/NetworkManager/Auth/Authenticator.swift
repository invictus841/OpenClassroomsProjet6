//
//  Authenticator.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

final class Authenticator {
    private let client: HTTPClient
    private let tokenStore: TokenStore
    
    init(client: HTTPClient = URLSessionHTTPClient(), tokenStore: TokenStore) {
        self.client = client
        self.tokenStore = tokenStore
    }
    
    func login(email: String, password: String) async throws -> Bool {
        let request = try AuthEndpoint.loginRequest(email: email, password: password)
        let (data, response) = try await client.request(from: request)
        let (token, isAdmin) = try AuthMapper.map(data, and: response)
        
        try tokenStore.insert(token.data(using: .utf8) ?? Data())
        return isAdmin
    }
}
