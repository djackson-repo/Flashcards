//
//  DecksView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI


struct DecksView: View {
    @Binding var username: String
    @Binding var isAuthenticated: Bool
    var body: some View {
        NavigationView() {
            VStack {
                Text("Deck View")
            }.navigationBarItems(trailing: LogoutView(isAuthenticated: $isAuthenticated))
        }
        
        
    }
}

struct LogoutView: View {
    @Binding var isAuthenticated: Bool
    var body: some View {
            Button(action: {
                isAuthenticated = false
            }) {
                Text("Logout")
                    .foregroundColor(.red)
                    .font(.headline)
            }
        }
}

