//
//  RegisterEndpoint.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 03/01/2025.
//

import Foundation

enum RegisterEndpoint {
    struct RegisterRequest: Encodable {
        let email: String
        let password: String
        let firstName: String
        let lastName: String
    }
    
    static func request(firstName: String, lastName: String, email: String, password: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/user/register")!
        let registerRequest = RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
        let data = try JSONEncoder().encode(registerRequest)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
    }
}
