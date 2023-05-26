//
//  CardModel.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import Foundation
struct CardModel : Codable {
    var cardId: Int64
    var deckId: Int64
    var front: String
    var back: String
    var timesStudied: Int64
}
