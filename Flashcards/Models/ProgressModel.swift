//
//  ProgressModel.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import Foundation
struct ProgressModel : Codable {
    let progressId: Int64
    let deckId: Int64
    let cardsStudied: Int
    let cardsMastered: Int
    let lastStudied: Date
}
