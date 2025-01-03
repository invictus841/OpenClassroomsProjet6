//
//  RegisterMapper.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 03/01/2025.
//

import Foundation

enum RegisterMapper {
    static func map(_ data: Data, and response: HTTPURLResponse) throws {
        guard response.statusCode == 201 else {
            throw NetworkError.invalidResponse
        }
    }
}
