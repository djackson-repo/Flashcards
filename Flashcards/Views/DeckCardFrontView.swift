//
//  DeckCardView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI

struct DeckCardFrontView: View {
    private var decks: [DeckModel] = []
    var body: some View {
        Text("Deck Card")
        // create a variable that shows the front of the card and gives the option to flip over the card
        // once it is flipped an option will shows up that allows you to go to the next card
        // if next is hit add 1 to the index count. Also add an if statement that checks to see if the index variable is greater than the decks array and if it is show a button that heads back to the decks view
    }
}

struct NextOrBack: View {
    
    var body: some View {
        Text("eegegeggge")
    }
}
