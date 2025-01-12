//
//  TokenStoreSpy.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 09/01/2025.
//

import Foundation
@testable import Vitesse

final class TokenStoreSpy: TokenStore {
    enum Message: Equatable {
        case insert(Data)
        case retrieve
        case delete
    }
    
    private(set) var messages = [Message]()
    private var retrievalResult: Result<Data, Error>?
    private var insertionResult: Result<Void, Error>?
    private var deletionResult: Result<Void, Error>?
    
    func insert(_ data: Data) throws {
        messages.append(.insert(data))
        try insertionResult?.get()
    }
    
    func retrieve() throws -> Data {
        messages.append(.retrieve)
        return try retrievalResult?.get() ?? Data()
    }
    
    func delete() throws {
        messages.append(.delete)
        try deletionResult?.get()
    }
    
    // Helper methods to control behavior
    func simulateRetrievalSuccess(_ data: Data) {
        retrievalResult = .success(data)
    }
    
    func simulateRetrievalFailure(_ error: Error) {
        retrievalResult = .failure(error)
    }
    
    func simulateInsertionSuccess() {
        insertionResult = .success(())
    }
    
    func simulateInsertionFailure(_ error: Error) {
        insertionResult = .failure(error)
    }
    
    func simulateDeletionSuccess() {
        deletionResult = .success(())
    }
    
    func simulateDeletionFailure(_ error: Error) {
        deletionResult = .failure(error)
    }
}
