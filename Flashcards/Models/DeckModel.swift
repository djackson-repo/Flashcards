//
//  DeckModel.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import Foundation
struct DeckModel : Codable {
    let deckId: Int64
    let userId: Int64
    let tagIds: [Int64]
    let name: String
    let description: String
}
