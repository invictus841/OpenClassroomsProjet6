//
//  URLSessionHTTPClient.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 02/01/2025.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private enum Error: Swift.Error {
        case noHTTPURLResponse
    }
    
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw Error.noHTTPURLResponse
        }
        
        return (data, httpURLResponse)
    }
}
