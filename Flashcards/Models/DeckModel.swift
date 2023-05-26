//
//  DeckModel.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import Foundation
struct DeckModel : Codable {
    var deckId: Int64
    var name: String
    var description: String
    var userId: Int64
    var tagId: Int64

}
