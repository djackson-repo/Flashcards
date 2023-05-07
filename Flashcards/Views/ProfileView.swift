//
//  ProfileView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/24/23.
//

import SwiftUI

struct ProfileView: View {
    @Binding var user: UserModel
    @Binding var isAuthenticated: Bool
    var body: some View {
        NavigationView() {
            VStack {
                Text("Profile View")
            }.navigationBarItems(leading: Text("Hello \(user.name)"), trailing: ProfileNavView(isAuthenticated: $isAuthenticated))
            
        }
    }
}


struct ProfileNavView: View {
    @Binding var isAuthenticated: Bool
    @State private var isProfileExpanded = false
    var body: some View {
        VStack {
            HStack {
                Button("Logout") {
                    isAuthenticated = false
                }
                .foregroundColor(.red)
                .font(.headline)
            
            }
        }
    }
}
