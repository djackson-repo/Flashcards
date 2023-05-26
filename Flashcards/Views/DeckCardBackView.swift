//
//  DeckCardBackView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI

struct DeckCardBackView: View {
    @Binding var isAuthenticated: Bool?
    @State var backside: String
    
    var body: some View {
        Text(backside)
    }
}

