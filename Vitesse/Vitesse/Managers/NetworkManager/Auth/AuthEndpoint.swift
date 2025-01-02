//
//  AuthEndpoint.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

enum AuthEndpoint {
    struct LoginRequest: Encodable {
        let email: String
        let password: String
    }
    
    static func loginRequest(email: String, password: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/user/auth")!
        let loginRequest = LoginRequest(email: email, password: password)
        let data = try JSONEncoder().encode(loginRequest)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
    }
}
