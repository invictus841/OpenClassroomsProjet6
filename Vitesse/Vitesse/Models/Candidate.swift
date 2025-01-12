//
//  Candidate.swift
//  Vitesse
//
//  Created by Alexandre Talatinian on 03/01/2025.
//

import Foundation

struct Candidate: Codable, Identifiable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, phone, linkedinURL, note, isFavorite
    }

    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let linkedinURL: String?
    let note: String?
    var isFavorite: Bool
    
    // Not included in CodingKeys, so it won't be part of JSON coding, as its for UI only
    var isSelected: Bool = false
    var name: String {
        "\(firstName) \(lastName)"
    }
}
