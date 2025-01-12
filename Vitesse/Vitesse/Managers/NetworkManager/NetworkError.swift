//
//  NetworkError.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidResponse
    case invalidData
    case invalidURL
    case unauthorized
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received"
        case .invalidURL:
            return "Invalid URL"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let message):
            return message
        }
    }
}
