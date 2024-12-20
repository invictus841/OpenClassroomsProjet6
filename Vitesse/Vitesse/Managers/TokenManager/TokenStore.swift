//
//  TokenStore.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 18/12/2024.
//

import Foundation

protocol TokenStore {
    func insert(_ data: Data) throws
    func retrieve() throws -> Data
    func delete() throws
}
