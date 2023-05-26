//
//  ProfileView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/24/23.
//

import SwiftUI

struct ProfileView: View {
    @Binding var user: UserModel
    @Binding var isAuthenticated: Bool?
    let progressController = ProgressController()
    @State var progress = ProgressModel(progressId: 0, deckId: 0, cardsStudied: 0, cardsMastered: 0)
    @State var progressError = ""
    
    var body: some View {
        NavigationView() {
            VStack {
                Text(user.name)
                Text("Cards Studied: \(progress.cardsStudied)")
            }.navigationBarItems(leading: Text("Hello \(user.name)"), trailing: ProfileNavView(isAuthenticated: $isAuthenticated))
                .onAppear(perform: getProgress)
            
        }
    }
    
    func getProgress() {
        progressController.getProgressByUser(userId: user.userId) { result in
            switch result {
            case .success(let progressresult):
                self.progress = progressresult.progress
            case .failure(let error):
                print("Error getting progress: \(error)")
                self.progressError = error.localizedDescription
            }
        }
    }
}




struct ProfileNavView: View {
    @Binding var isAuthenticated: Bool?
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

