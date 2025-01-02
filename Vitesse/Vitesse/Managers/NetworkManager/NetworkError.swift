//
//  NetworkError.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case unauthorized
    case serverError(String)
}
