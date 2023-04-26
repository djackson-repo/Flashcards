//
//  CardModel.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import Foundation
struct CardModel : Codable {
    let cardId: Int64
    let deckId: Int64
    let front_text: String
    let back_text: String
    let timesCorrect: Int
}
