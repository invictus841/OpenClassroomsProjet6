//
//  KeychainTokenStore.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 18/12/2024.
//

import Foundation

final class KeychainStore: TokenStore {

    private let key: String

    init(key: String = "com.vitesse.authtoken") {
        self.key = key
    }

    enum Error: Swift.Error {
        case insertFailed
        case retrieveFailed
        case deleteFailed
    }

    func insert(_ data: Data) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as Any,
            kSecValueData: data
        ] as CFDictionary

        guard SecItemAdd(query, nil) == noErr else {
            throw Error.insertFailed
        }
    }

    func retrieve() throws -> Data {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == noErr, let data = result as? Data else {
            throw Error.retrieveFailed
        }

        return data
    }

    func delete() throws {
        if existsInKeychain() {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key as Any
            ] as CFDictionary
            
            guard SecItemDelete(query) == noErr else {
                throw Error.deleteFailed
            }
        }
    }

    private func existsInKeychain() -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: kCFBooleanTrue as Any
        ] as CFDictionary
        
        let status = SecItemCopyMatching(query, nil)
        return status == noErr
    }
}

