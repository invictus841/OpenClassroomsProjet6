//
//  RegisterService.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 03/01/2025.
//

import Foundation

final class RegisterService {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) async throws {
        let request = try RegisterEndpoint.request(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )
        
        
        let (data, response) = try await client.request(from: request)
        
        
        try RegisterMapper.map(data, and: response)
    }
}
