//
//  DecksView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI


struct DecksView: View {
    @Binding var user: UserModel
    @Binding var isAuthenticated: Bool
    @State private var decks: [DeckModel] = []
    var body: some View {
        NavigationView() {
            VStack {
                Text("Deck View")
            }.navigationBarItems(leading: Text("Hello \(user.name)"), trailing: NavView(isAuthenticated: $isAuthenticated, user: $user))
            
        }
        
    }
}

struct NavView: View {
    @Binding var isAuthenticated: Bool
    @Binding var user : UserModel
    @State private var isProfileExpanded = false
    var body: some View {
        VStack {
            HStack {
                Button("Logout") {
                    isAuthenticated = false
                }
                .foregroundColor(.red)
                .font(.headline)
                
                NavigationLink(destination: ProfileView(user: $user, isAuthenticated: $isAuthenticated)) {
                    Text("Profile")
                        .font(.subheadline)  // Adjust the font size here
                        .padding(.horizontal, 8)  // Adjust the horizontal padding here
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}










