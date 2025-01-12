//
//  HTTPClientStub.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 10/01/2025.
//

import Foundation
@testable import Vitesse

final class HTTPClientStub: HTTPClient {
    
    private let result: Result<(Data, HTTPURLResponse), Error>
    private(set) var requestedURLs: [URLRequest] = []
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(request)
        
        return try result.get()
    }
}
